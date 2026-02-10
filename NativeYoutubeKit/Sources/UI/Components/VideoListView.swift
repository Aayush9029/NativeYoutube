import IdentifiedCollections
import Models
import SwiftUI

public struct VideoListView: View {
    let videos: IdentifiedArrayOf<Video>
    let videoClickBehaviour: VideoClickBehaviour
    let onVideoTap: (Video) -> Void
    let useIINA: Bool
    let onPlayVideo: (Video) -> Void
    let onPlayInIINA: (Video) -> Void
    let onOpenInYouTube: (Video) -> Void
    let onCopyLink: (Video) -> Void
    let onShareLink: (URL) -> Void

    public init(
        videos: IdentifiedArrayOf<Video>,
        videoClickBehaviour: VideoClickBehaviour,
        onVideoTap: @escaping (Video) -> Void,
        useIINA: Bool = false,
        onPlayVideo: @escaping (Video) -> Void = { _ in },
        onPlayInIINA: @escaping (Video) -> Void = { _ in },
        onOpenInYouTube: @escaping (Video) -> Void = { _ in },
        onCopyLink: @escaping (Video) -> Void = { _ in },
        onShareLink: @escaping (URL) -> Void = { _ in }
    ) {
        self.videos = videos
        self.videoClickBehaviour = videoClickBehaviour
        self.onVideoTap = onVideoTap
        self.useIINA = useIINA
        self.onPlayVideo = onPlayVideo
        self.onPlayInIINA = onPlayInIINA
        self.onOpenInYouTube = onOpenInYouTube
        self.onCopyLink = onCopyLink
        self.onShareLink = onShareLink
    }

    public var body: some View {
        Group {
            if videos.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128)
                        .padding()
                    Text("Search for a Video")
                        .font(.title3)
                }
                .foregroundStyle(.quaternary)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(videos) { video in
                        VideoRowView(
                            video: video,
                            useIINA: useIINA,
                            onPlayVideo: { onPlayVideo(video) },
                            onPlayInIINA: { onPlayInIINA(video) },
                            onOpenInYouTube: { onOpenInYouTube(video) },
                            onCopyLink: { onCopyLink(video) },
                            onShareLink: onShareLink
                        )
                        .onTapGesture(count: 2) {
                            onVideoTap(video)
                        }
                    }
                    .padding(6)
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    let sampleVideos: IdentifiedArrayOf<Video> = [
        Video(
            id: "1",
            title: "First Video Title - Long title that might wrap to multiple lines",
            thumbnail: URL(string: "data:image/jpeg;base64,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")!,
            publishedAt: "Today",
            url: URL(string: "https://www.youtube.com/watch?v=1")!,
            channelTitle: "Channel One"
        ),
        Video(
            id: "2",
            title: "Second Video",
            thumbnail: URL(string: "https://i.ytimg.com/vi/0cqp7ZuHZ5M/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBey6QIE0dzUDpXvCpzT5sACYyTvg")!,
            publishedAt: "Yesterday",
            url: URL(string: "https://www.youtube.com/watch?v=2")!,
            channelTitle: "Channel Two"
        ),
        Video(
            id: "3",
            title: "Third Video",
            thumbnail: URL(string: "https://i.ytimg.com/vi/xkd36cJ6Z78/hq720.jpg?sqp=-oaymwEcCNAFEJQDSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLA4Pu1BaGgAD9aUpmUUz-0tf7Hmuw")!,
            publishedAt: "2 days ago",
            url: URL(string: "https://www.youtube.com/watch?v=3")!,
            channelTitle: "Channel Three"
        )
    ]

    VideoListView(
        videos: sampleVideos,
        videoClickBehaviour: .playVideo,
        onVideoTap: { video in
            print("Tapped video: \(video.title)")
        }
    )
}
#endif
