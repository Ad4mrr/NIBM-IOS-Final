import SwiftUI

struct QuizQuestionView: View {
    // answer state resets each question while the total score keeps increasing
    @Environment(AppState.self) private var appState
    let organID: String
    let questions: [QuizQuestion]

    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var correctAnswers = 0
    @State private var isShowingFeedback = false
    @State private var isFinished = false

    private var currentQuestion: QuizQuestion? {
        questions.indices.contains(currentQuestionIndex) ? questions[currentQuestionIndex] : nil
    }

    var body: some View {
        if isFinished {
            QuizResultView(
                correctAnswers: correctAnswers,
                totalQuestions: questions.count,
                organID: organID,
                retry: resetQuiz
            )
        } else if let currentQuestion {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    QuizQuestionHeader(
                        currentQuestion: currentQuestionIndex + 1,
                        totalQuestions: questions.count
                    )

                    Text(currentQuestion.prompt)
                        .font(.title2)
                        .fontWeight(.bold)
                        .accessibilityAddTraits(.isHeader)

                    VStack(spacing: 12) {
                        ForEach(currentQuestion.options.indices, id: \.self) { index in
                            Button {
                                selectedAnswerIndex = index
                            } label: {
                                QuizOptionRow(
                                    title: currentQuestion.options[index],
                                    letter: String(index + 1),
                                    isSelected: selectedAnswerIndex == index
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(isShowingFeedback)
                            .accessibilityLabel("Answer \(index + 1), \(currentQuestion.options[index])")
                            .accessibilityValue(selectedAnswerIndex == index ? "Selected" : "Not selected")
                            .accessibilityAddTraits(selectedAnswerIndex == index ? .isSelected : [])
                        }
                    }

                    if isShowingFeedback, let selectedAnswerIndex {
                        QuizFeedbackView(
                            question: currentQuestion,
                            wasCorrect: selectedAnswerIndex == currentQuestion.correctAnswerIndex,
                            isLastQuestion: currentQuestionIndex == questions.count - 1,
                            continueAction: advanceQuiz
                        )
                    } else {
                        Button("Check Answer") {
                            checkAnswer()
                        }
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundStyle(.white)
                        .background(
                            selectedAnswerIndex == nil ? AnatomyTheme.incomplete : AnatomyTheme.teal,
                            in: RoundedRectangle(cornerRadius: 14)
                        )
                        .disabled(selectedAnswerIndex == nil)
                    }
                }
                .padding()
            }
            .navigationTitle("\(currentQuestion.organTitle) Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .anatomyScreenBackground()
        } else {
            ContentUnavailableView(
                "Quiz unavailable",
                systemImage: "questionmark.circle",
                description: Text("No questions are available for this topic yet.")
            )
            .anatomyScreenBackground()
        }
    }

    private func checkAnswer() {
        // lock the selected option and reveal the explanation
        guard let selectedAnswerIndex, let currentQuestion else { return }
        if selectedAnswerIndex == currentQuestion.correctAnswerIndex {
            correctAnswers += 1
        }
        isShowingFeedback = true
    }

    private func advanceQuiz() {
        // the last question saves the best score before showing results
        if currentQuestionIndex == questions.count - 1 {
            appState.recordQuizResult(
                organID: organID,
                correctAnswers: correctAnswers,
                totalQuestions: questions.count
            )
            isFinished = true
        } else {
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            isShowingFeedback = false
        }
    }

    private func resetQuiz() {
        // return temporary values to the first-question state
        currentQuestionIndex = 0
        selectedAnswerIndex = nil
        correctAnswers = 0
        isShowingFeedback = false
        isFinished = false
    }
}

private struct QuizQuestionHeader: View {
    let currentQuestion: Int
    let totalQuestions: Int

    private var progress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(currentQuestion) / Double(totalQuestions)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Question \(currentQuestion) of \(totalQuestions)")
                    .font(.headline)
                Spacer()
                Text(progress, format: .percent.precision(.fractionLength(0)))
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.teal)
            }

            ProgressView(value: progress)
                .tint(AnatomyTheme.teal)
                .accessibilityLabel("Quiz progress")
                .accessibilityValue(Text(progress, format: .percent))
        }
    }
}

private struct QuizOptionRow: View {
    // colour and icon explain selected, correct and incorrect answers
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

private struct QuizFeedbackView: View {
    // this appears only after checking the current answer
    let question: QuizQuestion
    let wasCorrect: Bool
    let isLastQuestion: Bool
    let continueAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(
                wasCorrect ? "Correct!" : "Not quite",
                systemImage: wasCorrect ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
            .font(.title2.weight(.bold))
            .foregroundStyle(wasCorrect ? AnatomyTheme.teal : AnatomyTheme.heart)

            FeedbackCard(
                title: "Correct Answer",
                text: question.options[question.correctAnswerIndex],
                icon: "checkmark.seal.fill"
            )
            FeedbackCard(title: "Why?", text: question.explanation, icon: "book.fill")
            FeedbackCard(title: "Memory Tip", text: question.memoryTip, icon: "lightbulb.fill")

            Button(isLastQuestion ? "See Results" : "Next Question", action: continueAction)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, minHeight: 50)
                .foregroundStyle(.white)
                .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 14))
        }
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

private struct QuizResultView: View {
    // final score with retry and return-to-organ actions
    let correctAnswers: Int
    let totalQuestions: Int
    let organID: String
    let retry: () -> Void

    private var score: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalQuestions) * 100).rounded())
    }

    private var organ: Organ {
        SampleAnatomyData.organs.first { $0.id == organID } ?? SampleAnatomyData.heart
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Image(systemName: "trophy.fill")
                    .font(.largeTitle)
                    .foregroundStyle(AnatomyTheme.teal)
                    .accessibilityHidden(true)

                VStack(spacing: 6) {
                    Text("Quiz Complete")
                        .font(.largeTitle.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    Text("\(score)%")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(AnatomyTheme.teal)
                    Text("\(correctAnswers) of \(totalQuestions) correct")
                        .foregroundStyle(AnatomyTheme.textSecondary)
                }

                ViewThatFits(in: .horizontal) {
                    HStack {
                        ResultStatistic(value: "\(correctAnswers)", label: "Correct")
                        ResultStatistic(value: "\(totalQuestions - correctAnswers)", label: "Review")
                        ResultStatistic(value: "\(score)%", label: "Score")
                    }
                    VStack {
                        ResultStatistic(value: "\(correctAnswers)", label: "Correct")
                        ResultStatistic(value: "\(totalQuestions - correctAnswers)", label: "Review")
                        ResultStatistic(value: "\(score)%", label: "Score")
                    }
                }

                Button(action: retry) {
                    Label("Retry Quiz", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .foregroundStyle(.white)
                        .background(AnatomyTheme.teal, in: RoundedRectangle(cornerRadius: 14))
                }

                NavigationLink {
                    OrganOverviewView(organ: organ)
                } label: {
                    Text("Back to \(organ.title)")
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
                .font(.title2.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(AnatomyTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .anatomyCard()
    }
}
