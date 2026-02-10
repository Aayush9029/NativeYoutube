import Clients
import Dependencies
import Models
import Sharing
import SwiftUI
import UI

struct SearchVideosView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @Shared(.videoClickBehaviour) private var videoClickBehaviour

    var body: some View {
        VStack {
            switch coordinator.searchStatus {
            case .idle:
                EmptyStateView()
            case .searching:
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .completed:
                VideoListView(
                    videos: coordinator.searchResults,
                    videoClickBehaviour: videoClickBehaviour,
                    onVideoTap: { videoTapped($0) },
                    useIINA: true,
                    onPlayVideo: { playVideoTapped($0) },
                    onPlayInIINA: { playInIINATapped($0) },
                    onOpenInYouTube: { coordinator.openInYouTube($0) },
                    onCopyLink: { coordinator.copyVideoLink($0) },
                    onShareLink: { coordinator.shareVideo($0) }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let message):
                ErrorView(message: message)
            }
        }
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
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.tertiary)
            Text("Search for videos")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ErrorView: View {
    let message: String

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.red)
            Text("Error")
                .font(.title3)
                .fontWeight(.semibold)
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
#Preview {
    SearchVideosView()
        .environment(
            withDependencies({
                $0.searchClient = .previewValue
                $0.appStateClient = .previewValue
            }, operation: {
                AppCoordinator()
            })
        )
}
#endif
