import SwiftUI

struct GridView: View {
    let colors: [Color] = [.red, .blue, .green, .orange, .brown, .purple, .cyan, .indigo, .pink, .yellow, .teal, .yellow]
    
    @State private var gridSize: Int = 3  // Default is Easy (3x3)
    @State private var buttonColors: [Color] = []
    @State private var lastClickedButtonIndex: Int? = nil
    @State private var clickedColor: Color? = nil
    @State private var matchedIndices: Set<Int> = []
    
    @State private var score: Int = 0
    @State private var highScore: Int = 0
    @State private var showRestartButton: Bool = false
    @State private var isMemorizationPhase: Bool = true
    @State private var hasSelectedDifficulty: Bool = false  // Controls when to show difficulty selection
    @State private var showGameScreen: Bool = false  // Controls navigation between screens (game mode or game grid)
    
    @State private var timerValue: Int = 0
    @State private var timerRunning: Bool = false
    
    var columns: [GridItem] { Array(repeating: .init(.flexible()), count: gridSize) }
    
    func generateButtonColors() -> [Color] {
        let selectedColors = colors.shuffled().prefix((gridSize * gridSize) / 2) // Select half the grid size for pairs
        var colorsArray: [Color] = []
        
        for color in selectedColors {
            colorsArray.append(contentsOf: [color, color]) // Add pairs
        }
        
        // If grid size is odd (3x3), add one random extra color
        if (gridSize * gridSize) % 2 != 0 {
            colorsArray.append(colors.randomElement()!)
        }
        
        colorsArray.shuffle()
        return colorsArray
    }
    
    func restartGame() {
        score = 0
        lastClickedButtonIndex = nil
        clickedColor = nil
        matchedIndices = []
        buttonColors = generateButtonColors()
        showRestartButton = false
        isMemorizationPhase = true
        
        startTimer()  // Restart the timer
    }
    
    func startGame(withSize size: Int) {
        gridSize = size
        buttonColors = generateButtonColors()
        hasSelectedDifficulty = true
        showGameScreen = true  // Show game grid
        isMemorizationPhase = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            isMemorizationPhase = false
        }
        
        startTimer()  // Start the timer based on the selected difficulty
    }
    
    func startTimer() {
        // Set timer value based on difficulty
        switch gridSize {
        case 3:  // Easy (3x3)
            timerValue = 30
        case 4:  // Medium (4x4)
            timerValue = 60
        case 5:  // Hard (5x5)
            timerValue = 90
        default:
            timerValue = 30
        }
        
        timerRunning = true
        runTimer()
    }
    
    func runTimer() {
        guard timerRunning else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.timerValue > 0 {
                self.timerValue -= 1
                self.runTimer()  // Recurse every second
            } else {
                self.timerExpired()  // Timer expired
            }
        }
    }
    
    func timerExpired() {
        // Timer expired, restart the game
        restartGame()
    }
    
    var body: some View {
        VStack {
            if !showGameScreen {
                // Difficulty Selection Screen
                VStack {
                    Text("Select Difficulty")
                        .font(.largeTitle)
                        .padding()
                    
                    Button(action: { startGame(withSize: 3) }) {
                        Text("Easy")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { startGame(withSize: 4) }) {
                        Text("Medium")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: { startGame(withSize: 5) }) {
                        Text("Hard")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                // Game UI
                VStack {
                    Button(action: {
                        showGameScreen = false  // Go back to the game mode screen
                    }) {
                        Text("Back")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.leading)
                    
                    HStack {
                        Spacer()
                        
                        Text("Score: \(score)")
                            .font(.title)
                            .padding()
                        Spacer()
                        Text("High Score: \(highScore)")
                            .font(.title)
                            .padding()
                    }
                    
                    Text("Time Remaining: \(timerValue) seconds")
                        .font(.title)
                        .padding(.top)
                    
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach((0..<gridSize * gridSize), id: \.self) { index in
                            let color = buttonColors[index]
                            let isMatched = matchedIndices.contains(index)
                            let shouldShowColor = isMemorizationPhase || isMatched
                            
                            Button(action: {
                                guard !isMatched && !isMemorizationPhase else { return }
                                
                                if let lastIndex = lastClickedButtonIndex, lastIndex != index {
                                    if let clickedColor = clickedColor, clickedColor == color {
                                        score += 1
                                        matchedIndices.insert(lastIndex)
                                        matchedIndices.insert(index)
                                        
                                        if matchedIndices.count == (gridSize * gridSize) - ((gridSize * gridSize) % 2) {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                matchedIndices.removeAll()
                                                buttonColors = generateButtonColors()
                                                isMemorizationPhase = true
                                                
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                    isMemorizationPhase = false
                                                }
                                            }
                                        }
                                        
                                        lastClickedButtonIndex = nil
                                        self.clickedColor = nil
                                    } else {
                                        if score > highScore {
                                            highScore = score
                                        }
                                        
                                        score = 0
                                        showRestartButton = true
                                    }
                                } else {
                                    self.clickedColor = color
                                    self.lastClickedButtonIndex = index
                                }
                            }) {
                                Rectangle()
                                    .fill(shouldShowColor ? color : Color.gray.opacity(0.3))
                                    .aspectRatio(1, contentMode: .fit)  // Ensure each cell maintains a square shape
                                    .cornerRadius(10)
                                    .padding(2)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(showRestartButton || isMatched || isMemorizationPhase)
                        }
                    }
                    
                    if showRestartButton {
                        Button(action: {
                            restartGame()
                        }) {
                            Text("Restart")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if hasSelectedDifficulty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    isMemorizationPhase = false
                }
            }
        }
    }
}

#Preview {
    GridView()
}
