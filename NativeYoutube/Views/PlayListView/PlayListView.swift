import SwiftUI
import UI
import Dependencies
import Shared

struct PlayListView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Shared(.apiKey) private var apiKey
    @Shared(.playlistID) private var playlistID
    @Shared(.videoClickBehaviour) private var videoClickBehaviour
    
    @State private var isLoading = false
    @State private var hasError = false
    
    @Dependency(\.playlistClient) private var playlistClient
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if hasError || coordinator.playlistVideos.isEmpty {
                WelcomeView()
            } else {
                VideoListView(
                    videos: coordinator.playlistVideos,
                    videoClickBehaviour: videoClickBehaviour,
                    onVideoTap: { video in
                        Task {
                            await coordinator.handleVideoTap(video)
                        }
                    }
                )
            }
        }
        .onAppear {
            Task {
                await loadPlaylist()
            }
        }
        .onChange(of: playlistID) { _, newValue in
            Task {
                await loadPlaylist()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadPlaylist() async {
        @Shared(.logs) var logs
        
        isLoading = true
        hasError = false
        
        do {
            let videos = try await playlistClient.fetchVideos(apiKey, playlistID)
            await MainActor.run {
                coordinator.playlistVideos = videos
                coordinator.selectedPlaylist = playlistID
                isLoading = false
            }
            $logs.withLock { $0.append("PlayList: Loaded \(videos.count) videos") }
        } catch {
            await MainActor.run {
                hasError = true
                isLoading = false
            }
            $logs.withLock { $0.append("PlayList Error: \(error.localizedDescription)") }
        }
    }
}

#if DEBUG
#Preview {
    PlayListView()
        .environmentObject(
            withDependencies({
                $0.playlistClient = .previewValue
                $0.appStateClient = .previewValue
            }, operation: {
                AppCoordinator()
            })
        )
}
#endif