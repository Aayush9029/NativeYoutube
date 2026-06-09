import Models
import Sharing
import SwiftUI
import UI

struct ContentView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @Shared(.isPlaying) private var isPlaying
    @Shared(.currentlyPlaying) private var currentlyPlaying

    var body: some View {
        @Bindable var coordinator = coordinator
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                switch coordinator.currentPage {
                case .playlists:
                    PlayListView()
                case .search:
                    SearchVideosView()
                case .settings:
                    PreferencesView()
                }
                BottomBarView(
                    currentPage: $coordinator.currentPage,
                    searchQuery: $coordinator.searchQuery,
                    isPlaying: isPlaying,
                    currentlyPlaying: currentlyPlaying,
                    onSearch: { searchSubmitted() },
                    onQuit: coordinator.quitButtonTapped
                )
            }
            .frame(width: 360.0)
        }
        .animation(.easeInOut(duration: 0.2), value: coordinator.showingVideoPlayer)
    }

    private func searchSubmitted() {
        coordinator.pageButtonTapped(.search)
        Task { await coordinator.searchSubmitted(coordinator.searchQuery) }
    }
}

#if DEBUG
#Preview {
    ContentView()
        .environment(AppCoordinator())
}
#endif
