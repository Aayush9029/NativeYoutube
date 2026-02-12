import SwiftUI
import Models

struct VideoRowView: View {
    let video: Video
    @State private var isHovering = false
    let useIINA: Bool
    let onPlayVideo: () -> Void
    let onPlayInIINA: () -> Void
    let onOpenInYouTube: () -> Void
    let onCopyLink: () -> Void
    let onShareLink: (URL) -> Void
    
    init(
        video: Video,
        useIINA: Bool = false,
        onPlayVideo: @escaping () -> Void = {},
        onPlayInIINA: @escaping () -> Void = {},
        onOpenInYouTube: @escaping () -> Void = {},
        onCopyLink: @escaping () -> Void = {},
        onShareLink: @escaping (URL) -> Void = { _ in }
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
        ZStack {
            AsyncImage(url: video.thumbnail) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.25))
            }
            .overlay {
                LinearGradient(
                    colors: [
                        .black.opacity(isHovering ? 0.42 : 0.6),
                        .black.opacity(isHovering ? 0.57 : 0.75)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            }
            .blur(radius: isHovering ? 24 : 8)

            HStack(spacing: 10) {
                if !isHovering {
                    thumbnailView
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            )
                        )
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(video.title)
                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(isHovering ? 3 : 1)

                    Text(video.channelTitle)
                        .font(.system(size: isHovering ? 11 : 10, weight: .medium, design: .rounded))
                        .foregroundStyle(.white.opacity(0.84))

                    if !isHovering {
                        Text(video.publishedAt)
                            .font(.system(size: 10, weight: .regular, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                            .lineLimit(1)
                            .transition(.opacity)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(7)
        }
        .frame(height: 82)
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(
                    isHovering ? Color(red: 0.98, green: 0.41, blue: 0.55) : .white.opacity(0.2),
                    lineWidth: isHovering ? 1.5 : 1
                )
        )
        .shadow(
            color: isHovering ? Color(red: 0.96, green: 0.37, blue: 0.53).opacity(0.45) : .clear,
            radius: 12,
            y: 5
        )
        .contentShape(.rect(cornerRadius: 10))
        .onHover { hovering in
            isHovering = hovering
        }
        .animation(.spring(response: 0.26, dampingFraction: 0.84), value: isHovering)
        .contextMenu {
            VideoContextMenuView(
                video: video,
                useIINA: useIINA,
                onPlayVideo: onPlayVideo,
                onPlayInIINA: onPlayInIINA,
                onOpenInYouTube: onOpenInYouTube,
                onCopyLink: onCopyLink,
                onShareLink: onShareLink
            )
        }
    }

    private var thumbnailView: some View {
        AsyncImage(url: video.thumbnail) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
        }
        .frame(width: 128, height: 72)
        .clipShape(.rect(cornerRadius: 7))
        .overlay(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 2)
    }
}

#if DEBUG
#Preview {
    VideoRowView(
        video: Video(
            id: "0",
            title: "Olivia Rodrigo - good 4 u (Official Video)",
            thumbnail: URL(string: "https://i.ytimg.com/vi/gNi_6U5Pm_o/mqdefault.jpg")!,
            publishedAt: "Yesterday",
            url: URL(string: "https://www.youtube.com/watch?v=gNi_6U5Pm_o")!,
            channelTitle: "OliviaRodrigoVEVO"
        )
    )
}
#endif
