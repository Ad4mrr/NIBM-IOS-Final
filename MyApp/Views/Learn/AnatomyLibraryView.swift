import SwiftUI

struct AnatomyLibraryView: View {
    // main starting point browsing organs searching
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                LibraryHeader()

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 340), spacing: 22)],
                    spacing: 22
                ) {
                    ForEach(SampleAnatomyData.organs) { organ in
                        NavigationLink {
                            OrganOverviewView(organ: organ)
                        } label: {
                            OrganDiscoveryCard(organ: organ)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .adaptiveContentWidth(1_050)
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .toolbar(.hidden, for: .navigationBar)
        .anatomyScreenBackground()
    }
}

private struct LibraryHeader: View {
    // title plus shortcuts saved items search
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                SectionTitle(
                    "Explore the human body",
                    eyebrow: "ANATOMY LIBRARY",
                    subtitle: "Choose a system and learn it layer by layer."
                )
                Spacer()
                NavigationLink {
                    FavouritesView()
                } label: {
                    Image(systemName: "bookmark.fill")
                        .frame(width: 44, height: 44)
                        .background(AnatomyTheme.surfaceStrong, in: Circle())
                }
                .accessibilityLabel("Saved structures")
            }

            NavigationLink {
                SearchView()
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                    Text("Search organs, lessons, structures")
                    Spacer()
                    Image(systemName: "slider.horizontal.3")
                }
                .font(.subheadline)
                .foregroundStyle(AnatomyTheme.textSecondary)
                .padding(.horizontal, 16)
                .frame(minHeight: 52)
                .background(AnatomyTheme.surface, in: RoundedRectangle(cornerRadius: 18))
                .overlay { RoundedRectangle(cornerRadius: 18).stroke(.white.opacity(0.08)) }
            }
        }
        .padding(.top, 14)
    }
}

private struct OrganDiscoveryCard: View {
    // visual summary organ learning grid
    let organ: Organ

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AnatomyTheme.organGradient(for: organ.id))

            OrganArtworkView(organID: organ.id, size: 190)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 16)
                .offset(y: 15)

            VStack(alignment: .leading, spacing: 10) {
                Text(organ.systemName.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(AnatomyTheme.organColor(for: organ.id))
                Text(organ.title)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                Text(organ.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: 190, alignment: .leading)

                Spacer()

                HStack {
                    Label("\(organ.lessons.count) lessons", systemImage: "book.closed.fill")
                    Label("Quiz", systemImage: "checkmark.circle.fill")
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.82))
            }
            .padding(22)
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.1)) }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(organ.title), \(organ.systemName), \(organ.lessons.count) lessons and quiz")
    }
}
