import SwiftUI
import Models

public struct VideoContextMenuView: View {
    let video: Video
    let useIINA: Bool
    let onPlayVideo: () -> Void
    let onPlayInIINA: () -> Void
    let onOpenInYouTube: () -> Void
    let onCopyLink: () -> Void
    let onShareLink: (URL) -> Void
    
    public init(
        video: Video,
        useIINA: Bool,
        onPlayVideo: @escaping () -> Void,
        onPlayInIINA: @escaping () -> Void,
        onOpenInYouTube: @escaping () -> Void,
        onCopyLink: @escaping () -> Void,
        onShareLink: @escaping (URL) -> Void
    ) {
        self.video = video
        self.useIINA = useIINA
        self.onPlayVideo = onPlayVideo
        self.onPlayInIINA = onPlayInIINA
        self.onOpenInYouTube = onOpenInYouTube
        self.onCopyLink = onCopyLink
        self.onShareLink = onShareLink
    }
    
    public var body: some View {
        Group {
            if useIINA {
                Button(action: onPlayInIINA) {
                    Label("Play Video in IINA", systemImage: "play.circle")
                }
                Divider()
            }
            
            Button(action: onPlayVideo) {
                Label("Play Video", systemImage: "play.circle")
            }
            
            Divider()
            
            Button(action: onOpenInYouTube) {
                Label("Open in youtube.com", systemImage: "globe")
            }
            
            Divider()
            
            Button(action: onCopyLink) {
                Label("Copy Link", systemImage: "link")
            }
            
            Divider()
            
            Button(action: { onShareLink(video.url) }) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        }
    }
}

#if DEBUG
#Preview {
    let sampleVideo = Video(
        id: "123",
        title: "Sample Video Title",
        thumbnail: URL(string: "https://via.placeholder.com/140x100")!,
        publishedAt: "Today",
        url: URL(string: "https://www.youtube.com/watch?v=123")!,
        channelTitle: "Sample Channel"
    )
    
    return VStack(spacing: 20) {
        Menu("Video Menu with IINA") {
            VideoContextMenuView(
                video: sampleVideo,
                useIINA: true,
                onPlayVideo: { print("Play video") },
                onPlayInIINA: { print("Play in IINA") },
                onOpenInYouTube: { print("Open in YouTube") },
                onCopyLink: { print("Copy link") },
                onShareLink: { url in print("Share link: \(url)") }
            )
        }
        
        Menu("Video Menu without IINA") {
            VideoContextMenuView(
                video: sampleVideo,
                useIINA: false,
                onPlayVideo: { print("Play video") },
                onPlayInIINA: { print("Play in IINA") },
                onOpenInYouTube: { print("Open in YouTube") },
                onCopyLink: { print("Copy link") },
                onShareLink: { url in print("Share link: \(url)") }
            )
        }
    }
    .padding()
}
#endif