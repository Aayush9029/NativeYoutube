import Foundation
import Models

func makeVideo(
    id: String = "testId123",
    title: String = "Test Video Title",
    thumbnail: URL = URL(string: "https://i.ytimg.com/vi/testId123/hqdefault.jpg")!,
    publishedAt: String = "Today",
    url: URL = URL(string: "https://www.youtube.com/watch?v=testId123")!,
    channelTitle: String = "Test Channel"
) -> Video {
    Video(
        id: id,
        title: title,
        thumbnail: thumbnail,
        publishedAt: publishedAt,
        url: url,
        channelTitle: channelTitle
    )
}
