import SwiftUI

struct SearchView: View {
    @State private var searchText = ""

    private static let allResults = SearchResult.makeAllResults()

    private var visibleResults: [SearchResult] {
        guard !searchText.isEmpty else {
            return Self.allResults
        }

        return Self.allResults.filter { result in
            result.searchableText.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List(visibleResults) { result in
            NavigationLink {
                SearchDestinationView(destination: result.destination)
            } label: {
                SearchResultRow(
                    title: result.title,
                    detail: result.detail,
                    symbol: result.symbol,
                    organID: result.organID
                )
            }
        }
        .searchable(text: $searchText, prompt: "Search lessons and structures")
        .navigationTitle("Search")
        .overlay {
            if visibleResults.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}

private struct SearchResult: Identifiable {
    enum Destination {
        case lesson(AnatomyLesson)
        case structure(AnatomyStructure)
    }

    let id: String
    let title: String
    let detail: String
    let symbol: String
    let organID: String
    let searchableText: String
    let destination: Destination

    static func makeAllResults() -> [SearchResult] {
        let lessonResults = SampleAnatomyData.organs.flatMap { organ in
            organ.lessons.map { lesson in
                SearchResult(
                    id: "lesson-\(lesson.id)",
                    title: lesson.title,
                    detail: "\(organ.title) • Lesson",
                    symbol: "book.fill",
                    organID: organ.id,
                    searchableText: [
                        lesson.title,
                        lesson.summary,
                        lesson.keyTakeaway,
                        organ.title,
                        organ.systemName,
                        "lesson"
                    ].joined(separator: " "),
                    destination: .lesson(lesson)
                )
            }
        }

        let structureResults = SampleAnatomyData.structures.map { structure in
            let organID = SampleAnatomyData.organs.first {
                $0.title == structure.organTitle
            }?.id ?? "heart"

            return SearchResult(
                id: "structure-\(structure.id)",
                title: structure.title,
                detail: "\(structure.organTitle) • \(structure.topic)",
                symbol: "scope",
                organID: organID,
                searchableText: [
                    structure.title,
                    structure.organTitle,
                    structure.topic,
                    structure.pathway,
                    structure.functionDescription,
                    structure.tags.joined(separator: " "),
                    "structure"
                ].joined(separator: " "),
                destination: .structure(structure)
            )
        }

        return (lessonResults + structureResults).sorted {
            if $0.detail == $1.detail {
                return $0.title.localizedStandardCompare($1.title) == .orderedAscending
            }
            return $0.detail.localizedStandardCompare($1.detail) == .orderedAscending
        }
    }
}

private struct SearchDestinationView: View {
    let destination: SearchResult.Destination

    var body: some View {
        switch destination {
        case .lesson(let lesson):
            LessonDetailView(lesson: lesson)
        case .structure(let structure):
            StructureDetailView(structure: structure)
        }
    }
}

private struct SearchResultRow: View {
    let title: String
    let detail: String
    let symbol: String
    let organID: String

    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
        } icon: {
            Image(systemName: symbol)
                .foregroundStyle(AnatomyTheme.organColor(for: organID))
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(detail)")
    }
}
