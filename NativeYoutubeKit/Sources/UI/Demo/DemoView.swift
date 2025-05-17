import SwiftUI
import Models

public struct DemoView: View {
    let videos: [Video] = [
        Video(
            id: "1",
            title: "SwiftUI Tutorial - Build a Complete App",
            thumbnail: URL(string: "https://via.placeholder.com/320x180")!,
            publishedAt: "Today",
            url: URL(string: "https://www.youtube.com/watch?v=test1")!,
            channelTitle: "Swift Academy"
        ),
        Video(
            id: "2",
            title: "Apple WWDC 2024 Keynote",
            thumbnail: URL(string: "https://via.placeholder.com/320x180")!,
            publishedAt: "Yesterday",
            url: URL(string: "https://www.youtube.com/watch?v=test2")!,
            channelTitle: "Apple"
        )
    ]
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(videos) { video in
                    VideoRowView(video: video)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    DemoView()
        .frame(width: 360, height: 600)
}