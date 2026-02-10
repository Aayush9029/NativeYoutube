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
                    .onAppear { playerDidAppear(player) }
                
            } else if isLoading {
                loadingView
            } else if let error = errorMessage {
                errorView(error)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
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
        .task { await extractAndPlayVideo() }
        .onAppear { setupCloseHandler() }
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        Button(action: closeButtonTapped) {
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
        ErrorView(
            error: error,
            onRetry: { Task { await extractAndPlayVideo() } },
            onClose: { windowClient.hidePanel() }
        )
    }
    
    // MARK: - Actions

    private func playerDidAppear(_ player: AVPlayer) {
        player.volume = 0.25
        player.play()
        isPlaying = true
    }

    private func closeButtonTapped() {
        player?.pause()
        windowClient.hidePanel()
    }

    private func setupCloseHandler() {
        windowClient.setCloseHandler { [weak player] in
            player?.pause()
            player = nil
        }
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
            VStack {
                Text("Video Playback Error")
                    .font(.headline)
                Text(error)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            HStack {
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

