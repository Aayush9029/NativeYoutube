import Models
import Shared
import SwiftUI
import UI

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Shared(.isPlaying) private var isPlaying
    @Shared(.currentlyPlaying) private var currentlyPlaying

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                switch coordinator.currentPage {
                case .playlists:
                    PlayListView()
                case .search:
                    SearchVideosView()
                case .settings:
                    PreferencesView() // Keep showing the playlists when settings is selected
                }
                BottomBarView(
                    currentPage: $coordinator.currentPage,
                    searchQuery: $coordinator.searchQuery,
                    isPlaying: isPlaying,
                    currentlyPlaying: currentlyPlaying,
                    onSearch: {
                        coordinator.navigateTo(.search)
                        Task {
                            await coordinator.search(coordinator.searchQuery)
                        }
                    },
                    onQuit: coordinator.quit
                )
            }
            .frame(width: 360.0)
        }
        .animation(.easeInOut(duration: 0.2), value: coordinator.showingVideoPlayer)
    }
}

#if DEBUG
#Preview {
    ContentView()
        .environmentObject(AppCoordinator())
}
#endif
