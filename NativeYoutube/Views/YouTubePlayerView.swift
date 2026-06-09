import AVKit
import SwiftUI
import UI

struct YouTubePlayerView: View {
    @State private var model: YouTubePlayerModel

    init(videoURL: URL, title: String) {
        _model = State(initialValue: YouTubePlayerModel(videoURL: videoURL, title: title))
    }
    
    var body: some View {
        ZStack {
            if let player = model.player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear { model.playerDidAppear(player) }
                
            } else if model.isLoading {
                loadingView
            } else if let error = model.errorMessage {
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
                model.hoverChanged(hovering)
            }
        }
        .task { await model.task() }
        .onAppear { model.viewAppeared() }
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        Button(action: model.closeButtonTapped) {
            Image(systemName: "xmark")
                .foregroundStyle(.secondary)
                .bold()
                .padding(8)
                .background(VisualEffectView())
                .clipShape(.circle)
        }
        .buttonStyle(.plain)
        .opacity(model.isHovering ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: model.isHovering)
    }
    
    private var loadingView: some View {
        LoadingView(title: model.title)
    }
    
    private func errorView(_ error: String) -> some View {
        ErrorView(
            error: error,
            onRetry: { Task { await model.retryButtonTapped() } },
            onClose: model.closeButtonTapped
        )
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
