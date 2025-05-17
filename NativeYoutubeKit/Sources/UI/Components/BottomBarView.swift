import Models
import SwiftUI

public struct BottomBarView: View {
    @Binding var currentPage: Pages
    @Binding var searchQuery: String
    var isPlaying: Bool
    var currentlyPlaying: String
    let onSearch: () -> Void
    let onQuit: () -> Void

    // For the morphing effect
    @Namespace private var searchNamespace
    // To auto‐focus the text field
    @FocusState private var isSearchFocused: Bool

    public init(
        currentPage: Binding<Pages>,
        searchQuery: Binding<String>,
        isPlaying: Bool,
        currentlyPlaying: String,
        onSearch: @escaping () -> Void,
        onQuit: @escaping () -> Void
    ) {
        self._currentPage = currentPage
        self._searchQuery = searchQuery
        self.isPlaying = isPlaying
        self.currentlyPlaying = currentlyPlaying
        self.onSearch = onSearch
        self.onQuit = onQuit
    }

    public var body: some View {
        HStack {
            // Playlists button
            CleanButton(page: .playlists, image: "music.note.list", binded: $currentPage)

            // Search icon <-> search bar morph
            ZStack {
                if currentPage != .search {
                    CleanButton(page: .search, image: "magnifyingglass", binded: $currentPage)
                } else {
                    TextField("Search...", text: $searchQuery, onCommit: onSearch)
                        .textFieldStyle(.plain)
                        .focused($isSearchFocused)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray.opacity(0.25))
                                .matchedGeometryEffect(id: "searchBG", in: searchNamespace)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.pink.opacity(0.25),
                                        lineWidth: 2)
                        )
                        .onAppear { isSearchFocused = true }
                        .transition(.opacity.combined(with: .blurReplace).combined(with: .move(edge: .leading)))
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentPage)

            Spacer(minLength: 0)

            // Now playing ticker or settings
            if currentPage != .search {
                if isPlaying {
                    ScrollView(.horizontal, showsIndicators: false) {
                        Text(currentlyPlaying)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .lineLimit(1)
                }
                CleanButton(page: .settings, image: "gear", binded: $currentPage)
                    .contextMenu {
                        Button("Quit app", systemImage: "power", action: onQuit)
                    }
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.75))
        )
    }
}

#if DEBUG
#Preview {
    struct PreviewWrapper: View {
        @State private var currentPage: Pages = .playlists
        @State private var searchQuery: String = ""

        var body: some View {
            VStack {
                BottomBarView(
                    currentPage: $currentPage,
                    searchQuery: $searchQuery,
                    isPlaying: true,
                    currentlyPlaying: "Example Video Title Playing Right Now",
                    onSearch: { print("Search triggered") },
                    onQuit: { print("Quit triggered") }
                )

                BottomBarView(
                    currentPage: $currentPage,
                    searchQuery: $searchQuery,
                    isPlaying: false,
                    currentlyPlaying: "",
                    onSearch: { print("Search triggered") },
                    onQuit: { print("Quit triggered") }
                )
                .padding()
            }
        }
    }

    return PreviewWrapper()
}
#endif
