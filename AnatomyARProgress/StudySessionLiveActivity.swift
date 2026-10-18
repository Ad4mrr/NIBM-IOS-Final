import ActivityKit
import SwiftUI
import WidgetKit

struct StudySessionAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let endTime: Date
        let isComplete: Bool
    }

    let lessonTitle: String
    let organName: String
    let durationMinutes: Int
}

struct StudySessionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StudySessionAttributes.self) { context in
            lockScreenView(context: context)
                .activityBackgroundTint(Color(red: 0.04, green: 0.09, blue: 0.13))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: symbol(for: context.attributes.organName))
                        .font(.title2)
                        .foregroundStyle(color(for: context.attributes.organName))
                }

                DynamicIslandExpandedRegion(.trailing) {
                    timer(endTime: context.state.endTime)
                        .font(.headline.monospacedDigit())
                }

                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.attributes.lessonTitle)
                            .font(.headline)
                        Text("\(context.attributes.organName) study session")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } compactLeading: {
                Image(systemName: symbol(for: context.attributes.organName))
                    .foregroundStyle(color(for: context.attributes.organName))
            } compactTrailing: {
                timer(endTime: context.state.endTime)
                    .font(.caption2.monospacedDigit())
                    .frame(width: 48)
            } minimal: {
                Image(systemName: "timer")
                    .foregroundStyle(.teal)
            }
            .keylineTint(color(for: context.attributes.organName))
        }
    }

    private func lockScreenView(
        context: ActivityViewContext<StudySessionAttributes>
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: symbol(for: context.attributes.organName))
                .font(.title)
                .foregroundStyle(color(for: context.attributes.organName))
                .frame(width: 46, height: 46)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.organName)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(context.attributes.lessonTitle)
                    .font(.headline)
                    .lineLimit(1)
                Text("\(context.attributes.durationMinutes)-minute study session")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            timer(endTime: context.state.endTime)
                .font(.title3.bold().monospacedDigit())
        }
        .padding()
    }

    private func timer(endTime: Date) -> some View {
        Text(timerInterval: Date.now...endTime, countsDown: true)
    }

    private func symbol(for organName: String) -> String {
        switch organName.lowercased() {
        case "brain": "brain.head.profile"
        case "lungs": "lungs.fill"
        default: "heart.fill"
        }
    }

    private func color(for organName: String) -> Color {
        switch organName.lowercased() {
        case "brain": .purple
        case "lungs": .blue
        default: .red
        }
    }
}
