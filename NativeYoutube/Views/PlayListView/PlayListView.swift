import Shared
import SwiftUI
import UI
import Dependencies

struct PlayListView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Shared(.videoClickBehaviour) private var videoClickBehaviour
    
    var body: some View {
        Group {
            switch coordinator.playlistStatus {
            case .loading:
                ProgressView()
            case .error, .idle:
                WelcomeView()
            case .completed:
                if coordinator.playlistVideos.isEmpty {
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
        }
        .onAppear {
            Task {
                await coordinator.loadPlaylist()
            }
        }
        .onChange(of: Shared(.playlistID).wrappedValue) { _, _ in
            Task {
                await coordinator.loadPlaylist()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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