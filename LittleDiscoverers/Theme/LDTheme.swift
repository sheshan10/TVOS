import SwiftUI

enum LDTheme {
    static let cream = Color(red: 1.0, green: 0.965, blue: 0.910)
    static let ink = Color(red: 0.122, green: 0.165, blue: 0.180)
    static let teal = Color(red: 0.055, green: 0.490, blue: 0.455)
    static let tealDark = Color(red: 0.035, green: 0.320, blue: 0.310)
    static let card = Color.white
    static let mist = Color(red: 0.890, green: 0.965, blue: 0.955)
    static let coral = Color(red: 0.710, green: 0.275, blue: 0.235)
    static let gold = Color(red: 0.855, green: 0.620, blue: 0.145)
    static let success = Color(red: 0.145, green: 0.510, blue: 0.365)

    static let displayFont = Font.system(size: 64, weight: .bold, design: .rounded)
    static let titleFont = Font.system(size: 42, weight: .bold, design: .rounded)
    static let subtitleFont = Font.system(size: 32, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 28, weight: .medium, design: .rounded)
    static let buttonFont = Font.system(size: 30, weight: .bold, design: .rounded)
    static let captionFont = Font.system(size: 24, weight: .semibold, design: .rounded)
}

enum LDButtonRole {
    case primary
    case secondary
    case card
}
