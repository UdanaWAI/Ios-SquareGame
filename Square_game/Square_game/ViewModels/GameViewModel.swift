//import SwiftUI
//
//class GameViewModel: ObservableObject {
//    let colors: [Color] = [.red, .blue, .green, .orange, .brown, .purple, .cyan, .indigo]
//
//    @Published var model = GameModel()
//    @Published var buttonColors: [Color] = []
//    @Published var showRestartButton: Bool = false
//    @Published var selectedIndexes: [Int] = []
//
//    private var unmatchedIndex: Int = -1
//
//    init() {
//        restartGame()
//    }
//
//    func generateButtonColors() -> [Color] {
//        let selectedColors = colors.shuffled().prefix(4)
//        var colorPairs = Array(selectedColors) + Array(selectedColors)
//
//        let uniqueColor = colors.filter { !selectedColors.contains($0) }.randomElement() ?? .gray
//        colorPairs.append(uniqueColor)
//
//        colorPairs.shuffle()
//        unmatchedIndex = colorPairs.firstIndex(of: uniqueColor) ?? -1 // Update unmatched index
//
//        return colorPairs
//    }
//
//    func handleButtonClick(index: Int) {
//        guard !selectedIndexes.contains(index), selectedIndexes.count < 2 else { return }
//
//        selectedIndexes.append(index)
//
//        if selectedIndexes.count == 2 {
//            checkForMatch()
//        }
//    }
//
//    private func checkForMatch() {
//        let firstColor = buttonColors[selectedIndexes[0]]
//        let secondColor = buttonColors[selectedIndexes[1]]
//
//        if selectedIndexes.contains(unmatchedIndex) {
//            handleMismatch()
//        } else if firstColor == secondColor {
//            handleCorrectMatch()
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.selectedIndexes.removeAll()
//            }
//        }
//    }
//
//    private func handleCorrectMatch() {
//        model.score += 1
//        selectedIndexes.removeAll()
//        buttonColors = generateButtonColors()
//    }
//
//    private func handleMismatch() {
//        model.highScore = max(model.highScore, model.score)
//        model.score = 0
//        showRestartButton = true
//    }
//
//    func restartGame() {
//        model = GameModel()
//        buttonColors = generateButtonColors()
//        selectedIndexes.removeAll()
//        showRestartButton = false
//    }
//}
