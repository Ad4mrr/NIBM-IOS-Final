import SwiftUI

struct SplashView: View {
    // logged-out start page
    var body: some View {
        NavigationStack {
            ZStack {
                AnatomyTheme.backgroundGradient.ignoresSafeArea()
                Circle()
                    .fill(AnatomyTheme.heart.opacity(0.2))
                    .frame(width: 360)
                    .blur(radius: 70)
                    .offset(x: 150, y: -250)

                VStack(spacing: 0) {
                    HStack {
                        Label("ANATOMYAR", systemImage: "waveform.path.ecg")
                            .font(.caption.weight(.bold))
                            .tracking(1.5)
                            .foregroundStyle(AnatomyTheme.teal)
                        Spacer()
                    }

                    Spacer()

                    OrganArtworkView(organID: "heart", size: 310)

                    VStack(spacing: 12) {
                        Text("Anatomy, made visible.")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .multilineTextAlignment(.center)
                            .accessibilityAddTraits(.isHeader)
                        Text("Short lessons, active recall and immersive exploration—built for the way you learn.")
                            .font(.body)
                            .foregroundStyle(AnatomyTheme.textSecondary)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    NavigationLink {
                        WelcomeView()
                    } label: {
                        HStack {
                            Text("Start exploring")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.background)
                        .padding(.horizontal, 20)
                        .frame(minHeight: 56)
                        .background(.white, in: RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(24)
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct WelcomeView: View {
    // welcome feature summary
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                SectionTitle(
                    "Learn deeply. Remember longer.",
                    eyebrow: "WELCOME TO ANATOMYAR",
                    subtitle: "A focused learning space for anatomy students."
                )

                HStack(spacing: -18) {
                    OrganArtworkView(organID: "heart", size: 130)
                    OrganArtworkView(organID: "brain", size: 130)
                    OrganArtworkView(organID: "lungs", size: 130)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 12) {
                    WelcomeFeature(symbol: "books.vertical.fill", title: "Guided learning", detail: "Clear, bite-sized anatomy lessons")
                    WelcomeFeature(symbol: "brain.head.profile.fill", title: "Active recall", detail: "Quizzes that strengthen memory")
                    WelcomeFeature(symbol: "arkit", title: "Spatial exploration", detail: "Explore labelled organ models in AR")
                }

                NavigationLink {
                    SignInView()
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .foregroundStyle(AnatomyTheme.background)
                        .background(.white, in: RoundedRectangle(cornerRadius: 18))
                }

                NavigationLink {
                    CreateAccountView()
                } label: {
                    Text("Create an account")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .foregroundStyle(AnatomyTheme.teal)
                        .overlay { RoundedRectangle(cornerRadius: 18).stroke(AnatomyTheme.teal.opacity(0.6)) }
                }
            }
            .adaptiveContentWidth(580)
            .padding(24)
        }
        .navigationBarBackButtonHidden()
        .anatomyScreenBackground()
    }
}

private struct WelcomeFeature: View {
    // welcome feature row
    let symbol: String
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(AnatomyTheme.teal)
                .frame(width: 46, height: 46)
                .background(AnatomyTheme.teal.opacity(0.12), in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(detail).font(.subheadline).foregroundStyle(AnatomyTheme.textSecondary)
            }
            Spacer()
        }
        .anatomyCard()
    }
}

struct SignInView: View {
    // profile load after login
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebaseService
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ModernAuthenticationForm(
            title: "Welcome back",
            subtitle: "Continue your anatomy journey",
            actionTitle: "Sign in",
            isWorking: firebaseService.isWorking,
            errorMessage: firebaseService.errorMessage,
            fields: {
                ModernField(title: "Email", symbol: "envelope.fill") {
                    TextField("student@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                ModernField(title: "Password", symbol: "lock.fill") {
                    SecureField("Enter your password", text: $password)
                        .textContentType(.password)
                }

                Button("Forgot password?") {
                    Task {
                        await firebaseService.sendPasswordReset(email: email)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                if let successMessage = firebaseService.successMessage {
                    Label(successMessage, systemImage: "checkmark.circle.fill")
                        .font(.footnote)
                        .foregroundStyle(AnatomyTheme.teal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            },
            action: {
                let profile = await firebaseService.signIn(
                    email: email,
                    password: password
                )

                guard firebaseService.isAuthenticated else { return }

                if let profile {
                    appState.applyRemoteProfile(profile)
                }

                appState.route = .main
            }
        )
        .onDisappear {
            firebaseService.clearError()
        }
    }
}

struct CreateAccountView: View {
    // new user onboarding
    @Environment(AppState.self) private var appState
    @Environment(FirebaseService.self) private var firebaseService
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showsOnboarding = false

    var body: some View {
        ModernAuthenticationForm(
            title: "Create your profile",
            subtitle: "Set up your learning space in seconds",
            actionTitle: "Create account",
            isWorking: firebaseService.isWorking,
            errorMessage: firebaseService.errorMessage,
            fields: {
                ModernField(title: "Name", symbol: "person.fill") {
                    TextField("Your name", text: $name)
                        .textContentType(.name)
                }
                ModernField(title: "Email", symbol: "envelope.fill") {
                    TextField("student@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                ModernField(title: "Password", symbol: "lock.fill") {
                    SecureField("Create a password", text: $password)
                        .textContentType(.newPassword)
                }
            },
            action: {
                let created = await firebaseService.createAccount(
                    name: name,
                    email: email,
                    password: password,
                    studyLevel: appState.studyLevel,
                    dailyGoalMinutes: appState.dailyGoalMinutes
                )

                if created {
                    appState.learnerName = name
                    showsOnboarding = true
                }
            }
        )
        .navigationDestination(isPresented: $showsOnboarding) {
            OnboardingIntroductionView()
        }
        .onDisappear {
            firebaseService.clearError()
        }
    }
}

private struct ModernAuthenticationForm<Fields: View>: View {
    // shared login form layout
    let title: String
    let subtitle: String
    let actionTitle: String
    let isWorking: Bool
    let errorMessage: String?
    @ViewBuilder let fields: Fields
    let action: () async -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                OrganArtworkView(organID: "brain", size: 140)
                    .frame(maxWidth: .infinity)
                SectionTitle(title, eyebrow: "YOUR LEARNING SPACE", subtitle: subtitle)
                VStack(spacing: 14) { fields }

                if let errorMessage {
                    Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                        .font(.footnote)
                        .foregroundStyle(AnatomyTheme.heart)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button {
                    Task {
                        await action()
                    }
                } label: {
                    HStack {
                        if isWorking {
                            ProgressView()
                                .tint(AnatomyTheme.background)
                        }
                        Text(isWorking ? "Please wait…" : actionTitle)
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .foregroundStyle(AnatomyTheme.background)
                    .background(.white, in: RoundedRectangle(cornerRadius: 18))
                }
                .disabled(isWorking)

                Text("Secure authentication powered by Firebase.")
                    .font(.caption)
                    .foregroundStyle(AnatomyTheme.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct ModernField<Field: View>: View {
    // shared input style
    let title: String
    let symbol: String
    @ViewBuilder let field: Field

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: symbol)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AnatomyTheme.textSecondary)
            field
                .padding(.horizontal, 15)
                .frame(minHeight: 52)
                .background(AnatomyTheme.surfaceStrong, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    SplashView()
}
