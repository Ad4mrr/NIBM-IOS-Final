import SwiftUI

enum AnatomyTheme {
    // color for all screens
    static let background = Color(red: 0.035, green: 0.055, blue: 0.09)
    static let backgroundRaised = Color(red: 0.06, green: 0.085, blue: 0.13)
    static let surface = Color.white.opacity(0.075)
    static let surfaceStrong = Color.white.opacity(0.12)
    static let teal = Color(red: 0.25, green: 0.92, blue: 0.82)
    static let darkTeal = Color(red: 0.12, green: 0.64, blue: 0.61)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.66)
    static let heart = Color(red: 1.0, green: 0.34, blue: 0.38)
    static let brain = Color(red: 0.69, green: 0.49, blue: 1.0)
    static let lungs = Color(red: 0.29, green: 0.69, blue: 1.0)
    static let incomplete = Color.white.opacity(0.16)

    static let backgroundGradient = LinearGradient(
        // main dark background
        colors: [backgroundRaised, background, Color(red: 0.025, green: 0.038, blue: 0.065)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func organColor(for organID: String) -> Color {
        // unknown IDs use the Heart colour as a safe visual fallback
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

    static func organImageName(for organID: String) -> String {
        switch organID {
        case "heart": "HeartOrgan"
        case "brain": "BrainOrgan"
        case "lungs": "LungsOrgan"
        default: "HeartOrgan"
        }
    }

    static func organGradient(for organID: String) -> LinearGradient {
        let color = organColor(for: organID)
        return LinearGradient(
            colors: [color.opacity(0.58), color.opacity(0.08)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
