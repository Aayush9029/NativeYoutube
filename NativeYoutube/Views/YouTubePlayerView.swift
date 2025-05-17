import AVKit
import Dependencies
import SwiftUI
import UI

struct YouTubePlayerView: View {
    let videoURL: URL
    let title: String
    
    @State private var player: AVPlayer? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var isHovering = true
    @State private var isPlaying = false
    
    @Dependency(\.youTubeKitClient) private var youTubeKit
    @Dependency(\.floatingWindowClient) private var windowClient
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                        isPlaying = true
                    }
                
            } else if isLoading {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VisualEffectView().ignoresSafeArea())
        .overlay(alignment: .topTrailing) {
            closeButton
                .padding(.trailing)
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hovering
            }
        }
        .onAppear {
            Task {
                await extractAndPlayVideo()
            }
            
            // Set up close handler to stop video
            windowClient.setCloseHandler { [weak player] in
                player?.pause()
                player = nil
            }
        }
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        Button(action: {
            player?.pause()
            windowClient.hidePanel()
        }) {
            Image(systemName: "xmark")
                .foregroundStyle(.secondary)
                .bold()
                .padding(8)
                .background(VisualEffectView())
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .opacity(isHovering ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isHovering)
    }
    
    private var loadingView: some View {
        LoadingView(title: title)
    }
    
    private func errorView(_ error: String) -> some View {
        ErrorView(error: error, 
            onRetry: {
                Task {
                    await extractAndPlayVideo()
                }
            },
            onClose: {
                windowClient.hidePanel()
            }
        )
    }
    
    // MARK: - Helper methods
    
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
                self.isPlaying = true
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

// MARK: - Subview Components

struct LoadingView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            VStack {
                Text("Loading video...")
                    .font(.headline)
                Text(title)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .glowEffect(lineWidth: 6, blurRadius: 48)
    }
}

private struct ErrorView: View {
    let error: String
    let onRetry: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.yellow)
            VStack{
                Text("Video Playback Error")
                    .font(.headline)
                Text(error)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            HStack{
                Button("Retry") {
                    onRetry()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.blue)
                Button("Close") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                
            }
        }
        .padding()
    }
}

#if DEBUG
struct YouTubePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Main player view
            YouTubePlayerView(
                videoURL: URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!,
                title: "Never Gonna Give You Up"
            )
            .frame(width: 800, height: 420)
            .preferredColorScheme(.dark)
            .previewDisplayName("Player View")
            
            // Loading state
            LoadingView(title: "Never Gonna Give You Up")
                .frame(width: 800, height: 420)
                .background(VisualEffectView())
                .preferredColorScheme(.dark)
                .previewDisplayName("Loading State")
            
            // Error state
            ErrorView(error: "Cannot play YouTube videos in preview mode", 
                onRetry: {
                    print("Retry tapped")
                },
                onClose: {
                    print("Close tapped")
                }
            )
            .frame(width: 800, height: 420)
            .background(VisualEffectView())
            .preferredColorScheme(.dark)
            .previewDisplayName("Error State")
        }
    }
}
#endif
