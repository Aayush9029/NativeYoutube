import SwiftUI
import Models

struct VideoRowView: View {
    let video: Video
    @State private var focused: Bool = false
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
        Group {
            ZStack {
                AsyncImage(url: video.thumbnail) { image in
                    image
                        .resizable()
                        .overlay {
                            Rectangle()
                                .fill(focused ? .ultraThinMaterial : .ultraThickMaterial)
                        }
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                
                HStack {
                    if !focused {
                        AsyncImage(url: video.thumbnail) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 72)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .cornerRadius(5)
                        .shadow(radius: 6, x: 2)
                        .padding(.leading, 4)
                        .padding(.vertical, 2)
                        .transition(.offset(x: -130))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(video.title)
                            .foregroundStyle(.primary)
                            .bold()
                            .lineLimit(focused ? 3 : 1)
                        
                        Text(video.channelTitle)
                            .foregroundStyle(.secondary)
                            .font(focused ? .caption : .footnote)
                        
                        if !focused {
                            Text(video.publishedAt)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
            }
            .clipped()
            .frame(height: 80)
            .containerShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(focused ? Color.pink : .gray.opacity(0.25), lineWidth: 2)
                .shadow(color: focused ? .pink : .blue.opacity(0), radius: 10)
            )
            .onTapGesture(perform: {
                focused.toggle()
            })
            .animation(.easeInOut, value: focused)
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