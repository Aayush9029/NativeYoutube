import APIClient
import Dependencies
import Foundation
import Models
import Shared

@DependencyClient
public struct SearchClient {
    public var searchVideos: (_ query: String, _ apiKey: String) async throws -> [Video] = { _, _ in [] }
}

extension SearchClient: DependencyKey {
    public static let liveValue = SearchClient(
        searchVideos: { query, apiKey in
            @Dependency(\.apiClient) var apiClient
            let request = SearchRequest(query: query, apiKey: apiKey)
            return try await apiClient.searchVideos(request)
        }
    )
    
    public static let previewValue = SearchClient(
        searchVideos: { query, _ in
            [
                Video(
                    id: "search1",
                    title: "Search Result: \(query)",
                    thumbnail: URL(string: "https://i.ytimg.com/vi/search1/hqdefault.jpg")!,
                    publishedAt: "2023-12-01T10:00:00Z",
                    url: URL(string: "https://www.youtube.com/watch?v=search1")!,
                    channelTitle: "Search Channel 1"
                ),
                Video(
                    id: "search2",
                    title: "Another Result for: \(query)",
                    thumbnail: URL(string: "https://i.ytimg.com/vi/search2/hqdefault.jpg")!,
                    publishedAt: "2023-12-01T09:00:00Z",
                    url: URL(string: "https://www.youtube.com/watch?v=search2")!,
                    channelTitle: "Search Channel 2"
                ),
                Video(
                    id: "search3",
                    title: "Popular video about \(query)",
                    thumbnail: URL(string: "https://i.ytimg.com/vi/search3/hqdefault.jpg")!,
                    publishedAt: "2023-12-01T08:00:00Z",
                    url: URL(string: "https://www.youtube.com/watch?v=search3")!,
                    channelTitle: "Popular Creator"
                )
            ]
        }
    )

    public static let testValue = SearchClient()
}

public extension DependencyValues {
    var searchClient: SearchClient {
        get { self[SearchClient.self] }
        set { self[SearchClient.self] = newValue }
    }
}