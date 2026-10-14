import SwiftUI

struct QuizQuestionView: View {
    let question: QuizQuestion
    @State private var selectedAnswerIndex: Int?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                QuizQuestionHeader()
                Text(question.prompt)
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(spacing: 12) {
                    ForEach(question.options.indices, id: \.self) { index in
                        Button {
                            selectedAnswerIndex = index
                        } label: {
                            QuizOptionRow(
                                title: question.options[index],
                                letter: String(index + 1),
                                isSelected: selectedAnswerIndex == index
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                NavigationLink {
                    QuizFeedbackView(
                        question: question,
                        wasCorrect: selectedAnswerIndex == question.correctAnswerIndex
                    )
                } label: {
                    Text("Check Answer")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                        .foregroundStyle(.white)
                        .background(
                            selectedAnswerIndex == nil ? AnatomyTheme.incomplete : AnatomyTheme.teal,
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                }
                .disabled(selectedAnswerIndex == nil)
            }
            .padding()
        }
        .navigationTitle("\(question.organTitle) Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct QuizQuestionHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Question 3 of 5")
                    .font(.headline)
                Spacer()
                Text("60% complete")
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.teal)
            }

            ProgressView(value: 0.6)
                .tint(AnatomyTheme.teal)
        }
    }
}

private struct QuizOptionRow: View {
    let title: String
    let letter: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(letter)
                .fontWeight(.bold)
                .frame(width: 36, height: 36)
                .background(
                    isSelected ? AnatomyTheme.teal : AnatomyTheme.background,
                    in: Circle()
                )
                .foregroundStyle(isSelected ? .white : AnatomyTheme.textPrimary)

            Text(title)
                .font(.body)
                .fontWeight(.medium)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AnatomyTheme.teal)
            }
        }
        .padding()
        .background(AnatomyTheme.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? AnatomyTheme.teal : Color.black.opacity(0.08), lineWidth: 1.5)
        }
    }
}

struct QuizFeedbackView: View {
    let question: QuizQuestion
    let wasCorrect: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Label(
                    wasCorrect ? "Correct!" : "Not quite",
                    systemImage: wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
                )
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(wasCorrect ? AnatomyTheme.teal : AnatomyTheme.heart)

                FeedbackCard(
                    title: "Correct Answer",
                    text: question.options[question.correctAnswerIndex],
                    icon: "checkmark.seal.fill"
                )
                FeedbackCard(
                    title: "Why?",
                    text: question.explanation,
                    icon: "book.fill"
                )
                FeedbackCard(
                    title: "Memory Tip",
                    text: question.memoryTip,
                    icon: "lightbulb.fill"
                )

                NavigationLink {
                    QuizResultView()
                } label: {
                    Text("Next Question")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                        .foregroundStyle(.white)
                        .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
        }
        .navigationTitle("Answer Feedback")
        .navigationBarTitleDisplayMode(.inline)
        .anatomyScreenBackground()
    }
}

private struct FeedbackCard: View {
    let title: String
    let text: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(AnatomyTheme.teal)
            Text(text)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .anatomyCard()
    }
}

struct QuizResultView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(AnatomyTheme.teal)

                VStack(spacing: 6) {
                    Text("Quiz Complete")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("80%")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundStyle(AnatomyTheme.teal)
                    Text("4 of 5 correct")
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                HStack {
                    ResultStatistic(value: "4", label: "Correct")
                    ResultStatistic(value: "1", label: "Review")
                    ResultStatistic(value: "80%", label: "Best")
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Area to review")
                        .font(.headline)
                    Label("Heart valves", systemImage: "book.fill")
                        .foregroundStyle(AnatomyTheme.heart)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .anatomyCard()

                PrimaryButton("Review Answers", systemImage: "doc.text.magnifyingglass") { }
                PrimaryButton("Retry Quiz", systemImage: "arrow.clockwise") { }

                NavigationLink {
                    OrganOverviewView(organ: SampleAnatomyData.heart)
                } label: {
                    Text("Back to Heart")
                        .fontWeight(.semibold)
                        .foregroundStyle(AnatomyTheme.teal)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .anatomyScreenBackground()
    }
}

private struct ResultStatistic: View {
    let value: String
    let label: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .anatomyCard()
    }
}
