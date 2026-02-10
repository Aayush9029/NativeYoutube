import Clients
import Dependencies
import Models
import Sharing
import SwiftUI
import UI

struct PlayListView: View {
    @Environment(AppCoordinator.self) private var coordinator
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
                        onVideoTap: { videoTapped($0) },
                        useIINA: true,
                        onPlayVideo: { playVideoTapped($0) },
                        onPlayInIINA: { playInIINATapped($0) },
                        onOpenInYouTube: { coordinator.openInYouTube($0) },
                        onCopyLink: { coordinator.copyVideoLink($0) },
                        onShareLink: { coordinator.shareVideo($0) }
                    )
                }
            }
        }
        .task { await coordinator.loadPlaylist() }
        .onChange(of: Shared(.playlistID).wrappedValue) { _, _ in
            playlistIDDidChange()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func videoTapped(_ video: Video) {
        Task { await coordinator.handleVideoTap(video) }
    }

    private func playVideoTapped(_ video: Video) {
        Task { await coordinator.playVideo(video) }
    }

    private func playInIINATapped(_ video: Video) {
        Task { await coordinator.playInIINA(video) }
    }

    private func playlistIDDidChange() {
        Task { await coordinator.loadPlaylist() }
    }
}

#if DEBUG
#Preview {
    PlayListView()
        .environment(
            withDependencies({
                $0.playlistClient = .previewValue
                $0.appStateClient = .previewValue
            }, operation: {
                AppCoordinator()
            })
        )
}
#endif
