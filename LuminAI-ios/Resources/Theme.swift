//
//  Theme.swift
//  LuminAI-ios
//
//  Created by Manuel Puchner on 01.03.24.
//

import SwiftUI

enum Theme {
    static let background = Color("background");
    static let cardBackground = Color("card-background")
    static let launchScreenBackground = Color("launch-screen-background")
    static let text = Color("text");
    static let border = Color("border");
    static let accent1 = Color("accent1");
    static let accent2 = Color("accent2");
    
    
    enum Accents {
        static let violet = Color("accent.violet")
        static let blue = Color("accent.blue")
        static let red = Color("accent.red")
        static let orange = Color("accent.orange")
    }
}

// Adapted from Stack Overflow answer by David Crow http://stackoverflow.com/a/43235
// Question: Algorithm to randomly generate an aesthetically-pleasing color palette by Brian Gianforcaro
// Method randomly generates a pastel color, and optionally mixes it with another color
import SwiftUI

func generateRandomPastelColor() -> Color {
    // Randomly generate number in closure with bias towards higher values
    let randomColorGenerator = { ()-> CGFloat in
        let baseValue = CGFloat(arc4random() % 128) / 256 // Bias towards higher values
        return baseValue + 0.5 // Adjust the bias strength as needed
    }
    
    let red: CGFloat = randomColorGenerator()
    let green: CGFloat = randomColorGenerator()
    let blue: CGFloat = randomColorGenerator()
    
    return Color(red: red, green: green, blue: blue)
}
