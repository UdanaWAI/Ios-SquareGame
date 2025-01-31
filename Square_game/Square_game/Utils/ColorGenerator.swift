import SwiftUI

class ColorGenerator {
    static let colors: [Color] = [.red, .blue, .green, .orange, .brown, .purple, .cyan, .indigo]
    
    static func generateUniqueColors() -> [Color] {
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
}
