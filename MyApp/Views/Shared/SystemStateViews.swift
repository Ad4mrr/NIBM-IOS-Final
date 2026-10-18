import SwiftUI

struct LoadingStateView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Anatomy Library")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Refreshing content...")
                .foregroundStyle(AnatomyTheme.textSecondary)

            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 20)
                    .fill(AnatomyTheme.incomplete.opacity(0.45))
                    .frame(height: 150)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Loading")
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

struct BackendErrorView: View {
    var body: some View {
        SystemMessageView(
            icon: "wifi.exclamationmark",
            title: "Couldn't refresh content",
            message: "Connection issue. Your downloaded learning data and progress are safe.",
            details: ["3 anatomy topics", "5 favourites", "Saved progress"],
            primaryTitle: "Try Again",
            secondaryTitle: "Continue Offline"
        )
        .navigationTitle("Backend Error")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct OfflineStateView: View {
    var body: some View {
        SystemMessageView(
            icon: "wifi.slash",
            title: "Offline Learning",
            message: "You're offline. Continue with content already saved on this device.",
            details: ["Heart downloaded", "Brain downloaded", "Lungs not downloaded"],
            primaryTitle: "Continue Offline",
            secondaryTitle: nil
        )
        .navigationTitle("Offline")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SystemMessageView: View {
    let icon: String
    let title: String
    let message: String
    let details: [String]
    let primaryTitle: String
    let secondaryTitle: String?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(AnatomyTheme.teal)
                .accessibilityHidden(true)

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)

            Text(message)
                .foregroundStyle(AnatomyTheme.textSecondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(details, id: \.self) { detail in
                    Label(detail, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(AnatomyTheme.darkTeal)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .anatomyCard()

            Spacer()

            PrimaryButton(primaryTitle) { }

            if let secondaryTitle {
                Button(secondaryTitle) { }
                    .fontWeight(.semibold)
                    .foregroundStyle(AnatomyTheme.teal)
            }
        }
        .padding()
        .anatomyScreenBackground()
    }
}
