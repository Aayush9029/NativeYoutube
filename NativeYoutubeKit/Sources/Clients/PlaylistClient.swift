import APIClient
import Foundation
import Models
import Shared
import Dependencies

@DependencyClient
public struct PlaylistClient {
    public var fetchVideos: (_ apiKey: String, _ playlistId: String) async throws -> [Video] = { _, _ in [] }
}

extension PlaylistClient: DependencyKey {
    public static let liveValue = PlaylistClient(
        fetchVideos: { apiKey, playlistId in
            @Dependency(\.apiClient) var apiClient
            let request = PlaylistRequest(playlistId: playlistId, apiKey: apiKey)
            return try await apiClient.fetchPlaylistVideos(request)
        }
    )
    
    public static let previewValue = PlaylistClient(
        fetchVideos: { _, _ in
            [
                Video(
                    id: "1",
                    title: "SwiftUI Tutorial - Building Your First App",
                    thumbnail: URL(string: "https://i.ytimg.com/vi/abc123/hqdefault.jpg")!,
                    publishedAt: "2023-12-01T10:00:00Z",
                    url: URL(string: "https://www.youtube.com/watch?v=abc123")!,
                    channelTitle: "SwiftUI Academy"
                ),
                Video(
                    id: "2",
                    title: "Advanced Swift Concurrency with async/await",
                    thumbnail: URL(string: "https://i.ytimg.com/vi/def456/hqdefault.jpg")!,
                    publishedAt: "2023-11-30T12:00:00Z",
                    url: URL(string: "https://www.youtube.com/watch?v=def456")!,
                    channelTitle: "iOS Developer"
                ),
                Video(
                    id: "3",
                    title: "Building a macOS Menu Bar App",
                    thumbnail: URL(string: "https://i.ytimg.com/vi/ghi789/hqdefault.jpg")!,
                    publishedAt: "2023-11-29T14:00:00Z",
                    url: URL(string: "https://www.youtube.com/watch?v=ghi789")!,
                    channelTitle: "Mac Development"
                )
            ]
        }
    )

    public static let testValue = PlaylistClient()
}

public extension DependencyValues {
    var playlistClient: PlaylistClient {
        get { self[PlaylistClient.self] }
        set { self[PlaylistClient.self] = newValue }
    }
}