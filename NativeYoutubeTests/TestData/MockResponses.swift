import Foundation
import Models
import APIClient

struct MockResponses {
    static let mockVideo1 = Video(
        id: "dQw4w9WgXcQ",
        title: "Rick Astley - Never Gonna Give You Up",
        thumbnail: URL(string: "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg")!,
        publishedAt: "2023-01-01T00:00:00Z",
        url: URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!,
        channelTitle: "Rick Astley"
    )
    
    static let mockVideo2 = Video(
        id: "M7lc1UVf-VE",
        title: "YouTube Developers Live: Embedded Web Player Customization",
        thumbnail: URL(string: "https://i.ytimg.com/vi/M7lc1UVf-VE/default.jpg")!,
        publishedAt: "2023-02-01T00:00:00Z",
        url: URL(string: "https://www.youtube.com/watch?v=M7lc1UVf-VE")!,
        channelTitle: "Google Developers"
    )
    
    static let mockVideo3 = Video(
        id: "kJQP7kiw5Fk",
        title: "Luis Fonsi - Despacito ft. Daddy Yankee",
        thumbnail: URL(string: "https://i.ytimg.com/vi/kJQP7kiw5Fk/default.jpg")!,
        publishedAt: "2023-03-01T00:00:00Z",
        url: URL(string: "https://www.youtube.com/watch?v=kJQP7kiw5Fk")!,
        channelTitle: "Luis Fonsi"
    )
    
    static let searchResults = [mockVideo1, mockVideo2, mockVideo3]
    
    static let playlistVideos = [
        Video(
            id: "aP-SQXTtWhY",
            title: "SwiftUI Tutorial - Building a Complete App",
            thumbnail: URL(string: "https://i.ytimg.com/vi/aP-SQXTtWhY/default.jpg")!,
            publishedAt: "2023-04-01T00:00:00Z",
            url: URL(string: "https://www.youtube.com/watch?v=aP-SQXTtWhY")!,
            channelTitle: "Google Developers"
        ),
        Video(
            id: "video2",
            title: "SwiftUI Tutorial #2",
            thumbnail: URL(string: "https://i.ytimg.com/vi/video2/default.jpg")!,
            publishedAt: "2023-04-02T00:00:00Z",
            url: URL(string: "https://www.youtube.com/watch?v=video2")!,
            channelTitle: "SwiftUI Academy"
        ),
        Video(
            id: "video3",
            title: "SwiftUI Tutorial #3",
            thumbnail: URL(string: "https://i.ytimg.com/vi/video3/default.jpg")!,
            publishedAt: "2023-04-03T00:00:00Z",
            url: URL(string: "https://www.youtube.com/watch?v=video3")!,
            channelTitle: "SwiftUI Academy"
        )
    ]
    
    // Mock search request for API client testing
    static let mockSearchRequest = SearchRequest(
        query: "SwiftUI Tutorial",
        apiKey: "mock-api-key"
    )
    
    // Mock playlist request for API client testing
    static let mockPlaylistRequest = PlaylistRequest(
        playlistId: "PLxxxxxxxx",
        apiKey: "mock-api-key"
    )
}