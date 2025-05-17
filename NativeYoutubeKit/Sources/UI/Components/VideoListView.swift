import SwiftUI
import Models

public struct VideoListView: View {
    let videos: [Video]
    let videoClickBehaviour: VideoClickBehaviour
    let onVideoTap: (Video) -> Void
    
    public init(
        videos: [Video],
        videoClickBehaviour: VideoClickBehaviour,
        onVideoTap: @escaping (Video) -> Void
    ) {
        self.videos = videos
        self.videoClickBehaviour = videoClickBehaviour
        self.onVideoTap = onVideoTap
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
                        VideoRowView(video: video)
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

#Preview {
    let sampleVideos = [
        Video(
            id: "1",
            title: "First Video Title - Long title that might wrap to multiple lines",
            thumbnail: URL(string: "https://via.placeholder.com/140x100/FF0000/FFFFFF?text=Video+1")!,
            publishedAt: "Today",
            url: URL(string: "https://www.youtube.com/watch?v=1")!,
            channelTitle: "Channel One"
        ),
        Video(
            id: "2",
            title: "Second Video",
            thumbnail: URL(string: "https://via.placeholder.com/140x100/00FF00/FFFFFF?text=Video+2")!,
            publishedAt: "Yesterday",
            url: URL(string: "https://www.youtube.com/watch?v=2")!,
            channelTitle: "Channel Two"
        ),
        Video(
            id: "3",
            title: "Third Video",
            thumbnail: URL(string: "https://via.placeholder.com/140x100/0000FF/FFFFFF?text=Video+3")!,
            publishedAt: "2 days ago",
            url: URL(string: "https://www.youtube.com/watch?v=3")!,
            channelTitle: "Channel Three"
        )
    ]
    
    return VStack {
        VideoListView(
            videos: sampleVideos,
            videoClickBehaviour: .playVideo,
            onVideoTap: { video in
                print("Tapped video: \(video.title)")
            }
        )
        .frame(height: 400)
        
        Divider()
        
        VideoListView(
            videos: [],
            videoClickBehaviour: .playVideo,
            onVideoTap: { _ in }
        )
        .frame(height: 200)
    }
    .padding()
}