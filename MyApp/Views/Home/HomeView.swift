import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    private let heart = SampleAnatomyData.heart

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 28) {
                HomeHeader(learnerName: appState.learnerName)
                ContinueLearningHero(
                    organ: heart,
                    progress: appState.progress(for: heart)
                )
                QuickStatsRow()
                OrganJourneySection(appState: appState)
            }
            .adaptiveContentWidth(900)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .toolbar(.hidden, for: .navigationBar)
        .anatomyScreenBackground()
    }
}

private struct HomeHeader: View {
    let learnerName: String

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("GOOD EVENING")
                    .font(.caption.weight(.bold))
                    .tracking(1.5)
                    .foregroundStyle(AnatomyTheme.teal)
                Text("Ready, \(learnerName)?")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(AnatomyTheme.textPrimary)
                    .accessibilityAddTraits(.isHeader)
            }

            Spacer()

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 42))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.white, AnatomyTheme.teal.opacity(0.45))
            }
            .accessibilityLabel("Profile and settings")
        }
        .padding(.top, 14)
    }
}

private struct ContinueLearningHero: View {
    let organ: Organ
    let progress: Double

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(AnatomyTheme.organGradient(for: organ.id))

            Circle()
                .fill(AnatomyTheme.heart.opacity(0.2))
                .frame(width: 240)
                .blur(radius: 30)
                .offset(x: 150, y: -60)

            OrganArtworkView(organID: organ.id, size: 220)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 36)
                .offset(y: -42)

            VStack(alignment: .leading, spacing: 14) {
                StatusBadge(title: "CONTINUE", systemImage: "play.fill", color: .white)

                Spacer()

                VStack(alignment: .leading, spacing: 5) {
                    Text("Heart valves")
                        .font(.title.weight(.bold))
                    Text("Lesson 3 · 8 min · \(progress, format: .percent.precision(.fractionLength(0)))")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.72))
                }

                NavigationLink {
                    LessonDetailView(lesson: SampleAnatomyData.heartLessons[2])
                } label: {
                    Label("Resume lesson", systemImage: "arrow.right")
                        .font(.headline)
                        .foregroundStyle(AnatomyTheme.background)
                        .padding(.horizontal, 18)
                        .frame(minHeight: 48)
                        .background(.white, in: Capsule())
                }
            }
            .padding(22)
        }
        .frame(height: 330)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.12))
        }
        .shadow(color: AnatomyTheme.heart.opacity(0.22), radius: 28, y: 18)
    }
}

private struct QuickStatsRow: View {
    var body: some View {
        HStack(spacing: 12) {
            QuickStat(value: "3", label: "day streak", symbol: "flame.fill", color: .orange)
            QuickStat(value: "80%", label: "quiz avg.", symbol: "checkmark.seal.fill", color: AnatomyTheme.teal)
            QuickStat(value: "5", label: "saved", symbol: "bookmark.fill", color: AnatomyTheme.brain)
        }
    }
}

private struct QuickStat: View {
    let value: String
    let label: String
    let symbol: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .foregroundStyle(color)
            Text(value)
                .font(.title2.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value), \(label)")
    }
}

private struct OrganJourneySection: View {
    let appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionTitle(
                "Your anatomy journey",
                eyebrow: "PROGRESS",
                subtitle: "Every lesson colours in a little more."
            )

            ForEach(SampleAnatomyData.organs) { organ in
                NavigationLink {
                    OrganOverviewView(organ: organ)
                } label: {
                    HStack(spacing: 14) {
                        OrganArtworkView(organID: organ.id, size: 74, showsGlow: false)
                        VStack(alignment: .leading, spacing: 7) {
                            Text(organ.title)
                                .font(.headline)
                                .foregroundStyle(AnatomyTheme.textPrimary)
                            ProgressView(value: appState.progress(for: organ))
                                .tint(AnatomyTheme.organColor(for: organ.id))
                            Text(
                                appState.progress(for: organ),
                                format: .percent.precision(.fractionLength(0))
                            )
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(AnatomyTheme.organColor(for: organ.id))
                        }
                        Image(systemName: "chevron.right")
                            .foregroundStyle(AnatomyTheme.textSecondary)
                    }
                    .anatomyCard()
                }
                .buttonStyle(.plain)
            }
        }
    }
}
