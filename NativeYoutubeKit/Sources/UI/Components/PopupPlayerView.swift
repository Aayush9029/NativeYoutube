import AVKit
import SwiftUI

public struct PopupPlayerView: View {
    let videoURL: URL
    let title: String
    let onClose: () -> Void
    
    @State private var player: AVPlayer? = nil
    @State private var isHoveringOnPlayer = false
    
    public init(videoURL: URL, title: String, onClose: @escaping () -> Void) {
        self.videoURL = videoURL
        self.title = title
        self.onClose = onClose
    }
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                if player != nil {
                    VideoPlayer(player: player)
                } else {
                    VStack {
                        ProgressView()
                        Text(title)
                            .frame(width: 420)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.tertiary)
                            .padding()
                    }
                    .padding()
                    .frame(width: 600, height: 400)
                    .background(.black)
                }
            }
            
            if isHoveringOnPlayer {
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.black.opacity(0.7)))
                        .padding()
                }
                .buttonStyle(.plain)
                .transition(.opacity)
            }
        }
        .onHover { hovering in
            withAnimation {
                isHoveringOnPlayer = hovering
            }
        }
        .onAppear {
            Task {
                // For now, use the video URL directly
                // In a real app, you might need to extract the streaming URL from YouTube
                player = AVPlayer(url: videoURL)
                player?.play()
            }
        }
    }
}