import SwiftUI
import AVKit
import UI
import Shared

struct YouTubePlayerView: View {
    let videoURL: URL
    let title: String
    let onClose: () -> Void
    
    @State private var player: AVPlayer? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @Dependency(\.youTubeKitClient) private var youTubeKit
    
    var body: some View {
        PopupPlayerView(title: title, onClose: onClose) {
            if let player = player {
                VideoPlayer(player: player)
                    .background(Color.black)
            } else {
                PopupPlayerView(
                    title: title,
                    isLoading: isLoading,
                    errorMessage: errorMessage,
                    onClose: onClose,
                    onRetry: {
                        Task {
                            await extractAndPlayVideo()
                        }
                    }
                )
                .background(Color.black)
            }
        }
        .onAppear {
            Task {
                await extractAndPlayVideo()
            }
        }
    }
    
    private func extractAndPlayVideo() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Use YouTubeKitClient to extract the stream URL
            let streamURL = try await youTubeKit.extractVideoURL(videoURL.absoluteString)
            
            // Create player with extracted URL
            await MainActor.run {
                self.player = AVPlayer(url: streamURL)
                self.player?.play()
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Failed to load video: \(error.localizedDescription)"
                if self.errorMessage?.contains("outside world") == true {
                    // This is a test/preview context without proper YouTube access
                    self.errorMessage = "Cannot play YouTube videos in preview mode"
                }
            }
        }
    }
}