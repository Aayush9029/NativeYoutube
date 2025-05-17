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
                    PreferencesView()
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

            // Overlay video player when showing
            if coordinator.showingVideoPlayer, let videoURL = coordinator.currentVideoURL {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        coordinator.hideVideoPlayer()
                    }

                YouTubePlayerView(
                    videoURL: videoURL,
                    title: coordinator.currentVideoTitle,
                    onClose: {
                        coordinator.hideVideoPlayer()
                    }
                )
                .frame(width: 600, height: 400)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(radius: 20)
                .transition(.scale.combined(with: .opacity))
            }
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
