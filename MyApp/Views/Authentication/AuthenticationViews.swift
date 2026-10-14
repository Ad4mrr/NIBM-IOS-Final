import SwiftUI

struct SplashView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(AnatomyTheme.teal.opacity(0.12))
                        .frame(width: 140, height: 140)

                    Image(systemName: "heart.text.clipboard.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(AnatomyTheme.teal)
                }

                VStack(spacing: 8) {
                    Text("AnatomyAR")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Learn anatomy. See it differently.")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                Spacer()

                NavigationLink {
                    WelcomeView()
                } label: {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                        .foregroundStyle(.white)
                        .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding(24)
            .anatomyScreenBackground()
        }
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "figure.mind.and.body")
                .font(.system(size: 86))
                .foregroundStyle(AnatomyTheme.teal)

            VStack(spacing: 10) {
                Text("Welcome to AnatomyAR")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Build confidence with short lessons, quizzes, visual progress and AR exploration.")
                    .font(.body)
                    .foregroundStyle(AnatomyTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            VStack(spacing: 12) {
                NavigationLink {
                    SignInView()
                } label: {
                    AuthenticationLinkLabel(title: "Sign In", filled: true)
                }

                NavigationLink {
                    CreateAccountView()
                } label: {
                    AuthenticationLinkLabel(title: "Create Account", filled: false)
                }
            }
        }
        .padding(24)
        .navigationBarBackButtonHidden()
        .anatomyScreenBackground()
    }
}

private struct AuthenticationLinkLabel: View {
    let title: String
    let filled: Bool

    var body: some View {
        Text(title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 50)
            .foregroundStyle(filled ? Color.white : AnatomyTheme.teal)
            .background(
                filled ? AnatomyTheme.teal : Color.clear,
                in: RoundedRectangle(cornerRadius: 14)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AnatomyTheme.teal, lineWidth: filled ? 0 : 1.5)
            }
    }
}

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        AuthenticationForm(
            title: "Welcome back",
            subtitle: "Sign in to continue learning",
            actionTitle: "Sign In",
            destination: OnboardingIntroductionView()
        ) {
            TextField("Email address", text: $email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textContentType(.password)
        }
        .navigationTitle("Sign In")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CreateAccountView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {
        AuthenticationForm(
            title: "Create your account",
            subtitle: "Your details are sample-only in Phase 1",
            actionTitle: "Create Account",
            destination: OnboardingIntroductionView()
        ) {
            TextField("Name", text: $name)
                .textContentType(.name)

            TextField("Email address", text: $email)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

            SecureField("Password", text: $password)
                .textContentType(.newPassword)

            SecureField("Confirm password", text: $confirmPassword)
                .textContentType(.newPassword)
        }
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AuthenticationForm<Fields: View>: View {
    let title: String
    let subtitle: String
    let actionTitle: String
    let destination: OnboardingIntroductionView
    @ViewBuilder let fields: Fields

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text(subtitle)
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                VStack(spacing: 14) {
                    fields
                        .textFieldStyle(.roundedBorder)
                        .frame(minHeight: 44)
                }

                NavigationLink(destination: destination) {
                    Text(actionTitle)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                        .foregroundStyle(.white)
                        .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 14))
                }

                Text("Authentication is not connected in Phase 1.")
                    .font(.footnote)
                    .foregroundStyle(AnatomyTheme.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
        .anatomyScreenBackground()
    }
}

#Preview {
    SplashView()
}
