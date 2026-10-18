import SwiftUI
import WidgetKit

private enum WidgetData {
    static let appGroupID = "group.com.ravinduwijethunga.AnatomyAR"

    static func currentEntry() -> ProgressEntry {
        let defaults = UserDefaults(suiteName: appGroupID) ?? .standard
        return ProgressEntry(
            date: .now,
            completedLessons: defaults.integer(forKey: "widget.completedLessons"),
            totalLessons: defaults.integer(forKey: "widget.totalLessons"),
            heartProgress: defaults.double(forKey: "widget.heart.progress"),
            brainProgress: defaults.double(forKey: "widget.brain.progress"),
            lungsProgress: defaults.double(forKey: "widget.lungs.progress")
        )
    }
}

struct ProgressEntry: TimelineEntry {
    let date: Date
    let completedLessons: Int
    let totalLessons: Int
    let heartProgress: Double
    let brainProgress: Double
    let lungsProgress: Double

    var overallProgress: Double {
        guard totalLessons > 0 else { return 0 }
        return Double(completedLessons) / Double(totalLessons)
    }

    static let preview = ProgressEntry(
        date: .now,
        completedLessons: 7,
        totalLessons: 13,
        heartProgress: 0.8,
        brainProgress: 0.5,
        lungsProgress: 0.25
    )
}

struct ProgressProvider: TimelineProvider {
    func placeholder(in context: Context) -> ProgressEntry {
        .preview
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (ProgressEntry) -> Void
    ) {
        completion(context.isPreview ? .preview : WidgetData.currentEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<ProgressEntry>) -> Void
    ) {
        let entry = WidgetData.currentEntry()
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 30, to: .now)
            ?? .now.addingTimeInterval(1_800)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

struct AnatomyARProgressEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    let entry: ProgressEntry

    var body: some View {
        if widgetFamily == .systemSmall {
            smallLayout
        } else {
            mediumLayout
        }
    }

    private var smallLayout: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("AnatomyAR", systemImage: "figure.arms.open")
                .font(.headline)
                .foregroundStyle(.teal)

            Spacer(minLength: 0)

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.12), lineWidth: 9)
                Circle()
                    .trim(from: 0, to: entry.overallProgress)
                    .stroke(.teal, style: StrokeStyle(lineWidth: 9, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Text(entry.overallProgress, format: .percent.precision(.fractionLength(0)))
                    .font(.title3.bold())
            }
            .frame(width: 72, height: 72)
            .frame(maxWidth: .infinity)

            Text("\(entry.completedLessons) of \(entry.totalLessons) lessons")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var mediumLayout: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Learning Progress", systemImage: "figure.arms.open")
                    .font(.headline)
                    .foregroundStyle(.teal)
                Spacer()
                Text(entry.overallProgress, format: .percent.precision(.fractionLength(0)))
                    .font(.title2.bold())
            }

            HStack(spacing: 14) {
                OrganWidgetProgress(
                    title: "Heart",
                    symbol: "heart.fill",
                    progress: entry.heartProgress,
                    color: .red
                )
                OrganWidgetProgress(
                    title: "Brain",
                    symbol: "brain.head.profile",
                    progress: entry.brainProgress,
                    color: .purple
                )
                OrganWidgetProgress(
                    title: "Lungs",
                    symbol: "lungs.fill",
                    progress: entry.lungsProgress,
                    color: .blue
                )
            }

            Text("\(entry.completedLessons) of \(entry.totalLessons) lessons completed")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct OrganWidgetProgress: View {
    let title: String
    let symbol: String
    let progress: Double
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(color)
            Text(progress, format: .percent.precision(.fractionLength(0)))
                .font(.caption.bold())
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AnatomyARProgress: Widget {
    let kind = "AnatomyARProgress"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProgressProvider()) { entry in
            AnatomyARProgressEntryView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [Color(red: 0.04, green: 0.09, blue: 0.13), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    for: .widget
                )
        }
        .configurationDisplayName("AnatomyAR Progress")
        .description("See your Heart, Brain, and Lungs lesson progress.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    AnatomyARProgress()
} timeline: {
    ProgressEntry.preview
}

#Preview(as: .systemMedium) {
    AnatomyARProgress()
} timeline: {
    ProgressEntry.preview
}
