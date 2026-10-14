import SwiftUI

struct LessonDetailView: View {
    let lesson: AnatomyLesson

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LessonHeroSection(lesson: lesson)
                LessonTakeawaySection(text: lesson.keyTakeaway)
                LessonExplanationSection()
                RelatedStructuresSection()
                LessonActions()
            }
            .padding()
        }
        .navigationTitle(lesson.title)
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct LessonHeroSection: View {
    let lesson: AnatomyLesson

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Lesson \(lesson.number) of 5")
                .font(.subheadline)
                .foregroundStyle(AnatomyTheme.heart)

            Text(lesson.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(AnatomyTheme.heart.opacity(0.12))
                    .frame(height: 190)

                VStack(spacing: 12) {
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.heart.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(AnatomyTheme.heart)
                    Text("One-way blood flow")
                        .font(.headline)
                }
            }

            HStack {
                LessonStat(value: "\(lesson.structureCount)", label: "structures")
                LessonStat(value: "\(lesson.durationMinutes) min", label: "duration")
                LessonStat(value: "1", label: "quiz")
            }
        }
    }
}

private struct LessonStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AnatomyTheme.surface, in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct LessonTakeawaySection: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Key Takeaway", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(AnatomyTheme.teal)
            Text(text)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

private struct LessonExplanationSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("How the valves work")
                .font(.title2)
                .fontWeight(.bold)

            Text("Four valves open and close as pressure changes inside the heart. This keeps blood moving through the chambers in the correct direction.")
                .foregroundStyle(AnatomyTheme.textSecondary)

            Label("Valves open when pressure behind them is greater.", systemImage: "1.circle.fill")
            Label("They close when pressure begins to reverse.", systemImage: "2.circle.fill")
        }
        .anatomyCard()
    }
}

private struct RelatedStructuresSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Related Structures")
                .font(.title2)
                .fontWeight(.bold)

            NavigationLink {
                StructureDetailView(structure: SampleAnatomyData.aorticValve)
            } label: {
                HStack {
                    Image(systemName: "heart.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AnatomyTheme.heart)
                    VStack(alignment: .leading) {
                        Text("Aortic Valve")
                            .font(.headline)
                        Text("Left ventricle → Aorta")
                            .font(.subheadline)
                            .foregroundStyle(AnatomyTheme.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
            }
            .buttonStyle(.plain)
        }
        .anatomyCard()
    }
}

private struct LessonActions: View {
    var body: some View {
        VStack(spacing: 12) {
            PrimaryButton("Mark Complete", systemImage: "checkmark.circle") { }

            NavigationLink {
                ARPlaceholderView()
            } label: {
                Label("Explore in AR", systemImage: "arkit")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 48)
                    .foregroundStyle(AnatomyTheme.teal)
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(AnatomyTheme.teal)
                    }
            }
        }
    }
}
