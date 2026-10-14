import SwiftUI

struct SplashView: View {
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
                            .font(.system(size: 43, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
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
                        .frame(height: 56)
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
                    WelcomeFeature(symbol: "arkit", title: "Spatial exploration", detail: "AR organ models are planned next")
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
            .padding(24)
        }
        .navigationBarBackButtonHidden()
        .anatomyScreenBackground()
    }
}

private struct WelcomeFeature: View {
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
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ModernAuthenticationForm(
            title: "Welcome back",
            subtitle: "Continue your anatomy journey",
            actionTitle: "Sign in",
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
            }
        )
    }
}

struct CreateAccountView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        ModernAuthenticationForm(
            title: "Create your profile",
            subtitle: "Set up your learning space in seconds",
            actionTitle: "Create account",
            fields: {
                ModernField(title: "Name", symbol: "person.fill") {
                    TextField("Your name", text: $name).textContentType(.name)
                }
                ModernField(title: "Email", symbol: "envelope.fill") {
                    TextField("student@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                ModernField(title: "Password", symbol: "lock.fill") {
                    SecureField("Create a password", text: $password).textContentType(.newPassword)
                }
            }
        )
    }
}

private struct ModernAuthenticationForm<Fields: View>: View {
    let title: String
    let subtitle: String
    let actionTitle: String
    @ViewBuilder let fields: Fields

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                OrganArtworkView(organID: "brain", size: 140)
                    .frame(maxWidth: .infinity)
                SectionTitle(title, eyebrow: "YOUR LEARNING SPACE", subtitle: subtitle)
                VStack(spacing: 14) { fields }
                NavigationLink {
                    OnboardingIntroductionView()
                } label: {
                    Text(actionTitle)
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 54)
                        .foregroundStyle(AnatomyTheme.background)
                        .background(.white, in: RoundedRectangle(cornerRadius: 18))
                }
                Text("Demo mode · Authentication will connect in the Firebase phase.")
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
                .frame(height: 52)
                .background(AnatomyTheme.surfaceStrong, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    SplashView()
}
