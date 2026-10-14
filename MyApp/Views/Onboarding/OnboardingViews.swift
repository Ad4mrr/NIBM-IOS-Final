import SwiftUI

struct OnboardingIntroductionView: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Learn your way")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 14) {
                OnboardingFeatureRow(
                    icon: "book.pages.fill",
                    title: "Learn",
                    description: "Follow short, structured anatomy lessons."
                )
                OnboardingFeatureRow(
                    icon: "checkmark.circle.fill",
                    title: "Test",
                    description: "Check your understanding with quick quizzes."
                )
                OnboardingFeatureRow(
                    icon: "arkit",
                    title: "Explore",
                    description: "View organs in augmented reality later."
                )
            }

            Spacer()

            NavigationLink {
                ProfileSetupView()
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 50)
                    .foregroundStyle(.white)
                    .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
        .anatomyScreenBackground()
    }
}

private struct OnboardingFeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AnatomyTheme.teal)
                .frame(width: 48, height: 48)
                .background(AnatomyTheme.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }

            Spacer()
        }
        .anatomyCard()
    }
}

struct ProfileSetupView: View {
    @State private var learnerName = "Ravindu"
    @State private var studyLevel = "Foundation"
    @State private var dailyGoal = 10

    private let levels = ["School", "Foundation", "Undergraduate", "General Interest"]

    var body: some View {
        Form {
            Section("Your profile") {
                TextField("Preferred name", text: $learnerName)

                Picker("Study level", selection: $studyLevel) {
                    ForEach(levels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
            }

            Section("Study goal") {
                Stepper("\(dailyGoal) minutes per day", value: $dailyGoal, in: 5...30, step: 5)
            }

            Section {
                NavigationLink {
                    MainTabView()
                } label: {
                    Text("Start Learning")
                        .fontWeight(.semibold)
                        .foregroundStyle(AnatomyTheme.teal)
                }
            }
        }
        .navigationTitle("Set Up Your Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}
