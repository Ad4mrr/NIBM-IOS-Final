import SwiftUI

struct SearchView: View {
    @State private var searchText = "ventricle"

    private let allResults = [
        SearchResult(id: "left-ventricle", title: "Left Ventricle", detail: "Heart • Chamber", symbol: "heart.fill"),
        SearchResult(id: "right-ventricle", title: "Right Ventricle", detail: "Heart • Chamber", symbol: "heart.fill"),
        SearchResult(id: "ventricles-overview", title: "Ventricles Overview", detail: "Heart • Lesson", symbol: "book.fill"),
        SearchResult(id: "aortic-valve", title: "Aortic Valve", detail: "Heart • Valve", symbol: "heart.circle.fill")
    ]

    private var visibleResults: [SearchResult] {
        guard !searchText.isEmpty else {
            return allResults
        }

        return allResults.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.detail.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List(visibleResults) { result in
            NavigationLink {
                StructureDetailView(structure: SampleAnatomyData.aorticValve)
            } label: {
                SearchResultRow(result: result)
            }
        }
        .searchable(text: $searchText, prompt: "Search anatomy")
        .navigationTitle("Search")
        .overlay {
            if visibleResults.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }
        }
    }
}

private struct SearchResult: Identifiable {
    let id: String
    let title: String
    let detail: String
    let symbol: String
}

private struct SearchResultRow: View {
    let result: SearchResult

    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(result.title)
                    .font(.headline)
                Text(result.detail)
                    .font(.subheadline)
                    .foregroundStyle(AnatomyTheme.textSecondary)
            }
        } icon: {
            Image(systemName: result.symbol)
                .foregroundStyle(AnatomyTheme.heart)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(result.title), \(result.detail)")
    }
}
