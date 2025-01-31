import SwiftUI

struct GridView: View {
    @StateObject private var viewModel = GameViewModel()
    private var row: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            HStack {
                Text("Score: \(viewModel.model.score)")
                    .font(.title)
                    .padding()
                Spacer()
                Text("High Score: \(viewModel.model.highScore)")
                    .font(.title)
                    .padding()
            }
            
            LazyVGrid(columns: row, spacing: 1) {
                ForEach((0..<9), id: \.self) { index in
                    let color = viewModel.buttonColors[index]
                    
                    Button(action: { viewModel.handleButtonClick(index: index) }) {
                        Rectangle()
                            .fill(color)
                            .frame(width: 100, height: 100)
                            .cornerRadius(15)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(viewModel.showRestartButton)
                }
            }
            
            if viewModel.showRestartButton {
                Button(action: { viewModel.restartGame() }) {
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
        .padding()
    }
}

#Preview {
    GridView()
}
