import Clients
import Dependencies
import Shared
import SwiftUI
import UI

struct SearchVideosView: View {
    @EnvironmentObject var coordinator: AppCoordinator
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
                    onVideoTap: { video in
                        Task {
                            await coordinator.handleVideoTap(video)
                        }
                    },
                    useIINA: true,
                    onPlayVideo: { video in
                        Task {
                            await coordinator.playVideo(video)
                        }
                    },
                    onPlayInIINA: { video in
                        Task {
                            await coordinator.playInIINA(video)
                        }
                    },
                    onOpenInYouTube: { video in
                        coordinator.openInYouTube(video)
                    },
                    onCopyLink: { video in
                        coordinator.copyVideoLink(video)
                    },
                    onShareLink: { url in
                        coordinator.shareVideo(url)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .error(let message):
                ErrorView(message: message)
            }
        }
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

struct ErrorView: View {
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
        .environmentObject(
            withDependencies({
                $0.searchClient = .previewValue
                $0.appStateClient = .previewValue
            }, operation: {
                AppCoordinator()
            })
        )
}
#endif
