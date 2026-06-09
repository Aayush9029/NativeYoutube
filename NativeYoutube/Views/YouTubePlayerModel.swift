import AVKit
import Dependencies
import Observation

@MainActor
@Observable
final class YouTubePlayerModel {
    let videoURL: URL
    let title: String
    var player: AVPlayer?
    var isLoading = true
    var errorMessage: String?
    var isHovering = true
    var isPlaying = false

    @ObservationIgnored @Dependency(\.youTubeKitClient) private var youTubeKit
    @ObservationIgnored @Dependency(\.floatingWindowClient) private var windowClient

    init(videoURL: URL, title: String) {
        self.videoURL = videoURL
        self.title = title
    }

    func task() async {
        await loadVideo()
    }

    func retryButtonTapped() async {
        await loadVideo()
    }

    func viewAppeared() {
        windowClient.setCloseHandler { [weak self] in
            self?.player?.pause()
            self?.player = nil
            self?.isPlaying = false
        }
    }

    func hoverChanged(_ isHovering: Bool) {
        self.isHovering = isHovering
    }

    func playerDidAppear(_ player: AVPlayer) {
        player.volume = 0.25
        player.play()
        isPlaying = true
    }

    func closeButtonTapped() {
        player?.pause()
        isPlaying = false
        windowClient.hidePanel()
    }

    private func loadVideo() async {
        isLoading = true
        errorMessage = nil

        do {
            let streamURL = try await youTubeKit.extractVideoURL(videoURL.absoluteString)
            player = AVPlayer(url: streamURL)
            player?.play()
            isPlaying = true
            isLoading = false
        } catch {
            player = nil
            isPlaying = false
            isLoading = false
            let message = "Failed to load video: \(error.localizedDescription)"
            errorMessage = message.contains("outside world")
                ? "Cannot play YouTube videos in preview mode"
                : message
        }
    }
}
