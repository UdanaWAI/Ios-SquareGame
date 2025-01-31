import SwiftUI

class GameViewModel: ObservableObject {
    let colors: [Color] = [.red, .blue, .green, .orange, .brown, .purple, .cyan, .indigo]
    
    @Published var model = GameModel()
    @Published var buttonColors: [Color] = []
    @Published var showRestartButton: Bool = false

    init() {
        buttonColors = generateButtonColors()
    }

    func generateButtonColors() -> [Color] {
        var uniqueColors = Set<Color>()
        let repeatedColor = colors.randomElement() ?? .black
        uniqueColors.insert(repeatedColor)
        
        while uniqueColors.count < 8 {
            if let randomColor = colors.randomElement(), !uniqueColors.contains(randomColor) {
                uniqueColors.insert(randomColor)
            }
        }

        var colorsArray = Array(uniqueColors) + [repeatedColor]
        colorsArray.shuffle()
        return colorsArray
    }

    func handleButtonClick(index: Int) {
        let color = buttonColors[index]
        
        if let lastClickedIndex = model.lastClickedButtonIndex, lastClickedIndex == index {
            return
        }
        
        if let clickedColor = model.clickedColor {
            if clickedColor == color {
                model.score += 1
                buttonColors = generateButtonColors()
                model.lastClickedButtonIndex = nil
                model.clickedColor = nil
            } else {
                if model.score > model.highScore {
                    model.highScore = model.score
                }
                model.score = 0
                showRestartButton = true
                model.clickedColor = color
                model.lastClickedButtonIndex = index
            }
        } else {
            model.clickedColor = color
            model.lastClickedButtonIndex = index
        }
        
        objectWillChange.send()
    }

    func restartGame() {
        model = GameModel()
        buttonColors = generateButtonColors()
        showRestartButton = false
        objectWillChange.send()
    }
}
