import SwiftUI

enum AnatomyTheme {
    static let background = Color(red: 0.96, green: 0.97, blue: 0.96)
    static let surface = Color.white
    static let teal = Color(red: 0.05, green: 0.55, blue: 0.52)
    static let darkTeal = Color(red: 0.02, green: 0.36, blue: 0.36)
    static let textPrimary = Color(red: 0.08, green: 0.13, blue: 0.18)
    static let textSecondary = Color(red: 0.35, green: 0.40, blue: 0.44)
    static let heart = Color(red: 0.90, green: 0.28, blue: 0.31)
    static let brain = Color(red: 0.50, green: 0.32, blue: 0.72)
    static let lungs = Color(red: 0.20, green: 0.48, blue: 0.78)
    static let incomplete = Color(red: 0.80, green: 0.82, blue: 0.83)

    static func organColor(for organID: String) -> Color {
        switch organID {
        case "heart":
            heart
        case "brain":
            brain
        case "lungs":
            lungs
        default:
            teal
        }
    }
}
