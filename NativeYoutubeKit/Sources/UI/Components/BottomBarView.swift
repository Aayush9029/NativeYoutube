import SwiftUI
import Models

public struct BottomBarView: View {
    @Binding var currentPage: Pages
    @Binding var searchQuery: String
    public var isPlaying: Bool
    public var currentlyPlaying: String
    public let onSearch: () -> Void
    public let onQuit: () -> Void
    
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
        Group {
            HStack {
                Group {
                    CleanButton(
                        page: .playlists,
                        image: "music.note.list",
                        binded: $currentPage
                    )
                    CleanButton(
                        page: .search,
                        image: "magnifyingglass",
                        binded: $currentPage
                    )
                }
                
                if currentPage == .search {
                    Group {
                        HStack {
                            TextField("Search..", text: $searchQuery)
                                .textFieldStyle(.plain)
                                .thinRoundedBG(padding: 6, radius: 6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                                )
                                .onSubmit(onSearch)
                        }
                        .transition(.offset(y: 120))
                        .animation(.linear, value: currentPage == .search)
                    }
                } else {
                    Group {
                        if isPlaying {
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text(currentlyPlaying)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .lineLimit(1)
                        }
                        
                        Spacer()
                    }
                    CleanButton(
                        page: .settings,
                        image: "gear",
                        binded: $currentPage
                    )
                    .contextMenu {
                        Button(action: onQuit) {
                            Label("Quit app", systemImage: "power")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
            }
            .labelStyle(.iconOnly)
            .thinRoundedBG(padding: 6, radius: 6)
        }
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
                .padding()
                
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
            .frame(width: 400)
        }
    }
    
    return PreviewWrapper()
}
#endif