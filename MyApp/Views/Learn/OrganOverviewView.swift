import SwiftUI

struct OrganOverviewView: View {
    let organ: Organ

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                OrganOverviewHeader(organ: organ)
                LessonListSection(lessons: organ.lessons)
                QuizStartCard(organTitle: organ.title)
            }
            .padding()
        }
        .navigationTitle(organ.title)
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct OrganOverviewHeader: View {
    let organ: Organ

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(organ.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(organ.systemName)
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                Spacer()
                StatusBadge(title: "AR READY", systemImage: "arkit", color: AnatomyTheme.organColor(for: organ.id))
            }

            OrganProgressView(
                title: organ.title,
                symbolName: organ.symbolName,
                progress: organ.progress,
                color: AnatomyTheme.organColor(for: organ.id),
                completedLessons: organ.completedLessonCount,
                totalLessons: organ.lessons.count,
                bestQuizScore: organ.bestQuizScore
            )

            Text(organ.description)
                .font(.body)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .anatomyCard()
    }
}

private struct LessonListSection: View {
    let lessons: [AnatomyLesson]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Guided Lessons")
                .font(.title2)
                .fontWeight(.bold)

            ForEach(lessons) { lesson in
                NavigationLink {
                    LessonDetailView(lesson: lesson)
                } label: {
                    LessonRow(lesson: lesson)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct LessonRow: View {
    let lesson: AnatomyLesson

    var body: some View {
        HStack(spacing: 14) {
            Text(lesson.number, format: .number.precision(.integerLength(2)))
                .font(.headline)
                .monospacedDigit()
                .foregroundStyle(AnatomyTheme.teal)

            VStack(alignment: .leading, spacing: 3) {
                Text(lesson.title)
                    .font(.headline)
                Text(lesson.status.rawValue)
                    .font(.caption)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }

            Spacer()

            Image(systemName: lesson.status.symbolName)
                .foregroundStyle(lesson.status == .completed ? AnatomyTheme.teal : AnatomyTheme.textSecondary)
        }
        .anatomyCard()
    }
}

private struct QuizStartCard: View {
    let organTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(organTitle) Quiz", systemImage: "questionmark.circle.fill")
                .font(.title3)
                .fontWeight(.bold)

            Text("Five quick questions to check your understanding.")
                .foregroundStyle(AnatomyTheme.textSecondary)

            NavigationLink {
                QuizQuestionView(question: SampleAnatomyData.quizQuestion)
            } label: {
                Text("Start Quiz")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 46)
                    .foregroundStyle(.white)
                    .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .anatomyCard()
    }
}
