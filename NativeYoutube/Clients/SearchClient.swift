import Foundation
import Shared
import Models
import APIClient

@DependencyClient
public struct SearchClient {
    public var searchVideos: (_ query: String, _ apiKey: String) async throws -> [Video] = { _, _ in [] }
}

extension SearchClient: TestDependencyKey {
    public static let previewValue = SearchClient(
        searchVideos: { query, _ in
            // Return mock search results based on query for previews
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

extension DependencyValues {
    public var searchClient: SearchClient {
        get { self[SearchClient.self] }
        set { self[SearchClient.self] = newValue }
    }
}

extension SearchClient {
    public static func live() -> Self {
        @Dependency(\.apiClient) var apiClient
        
        return SearchClient(
            searchVideos: { query, apiKey in
                let request = SearchRequest(
                    query: query,
                    maxResults: 20,
                    apiKey: apiKey
                )
                return try await apiClient.searchVideos(request)
            }
        )
    }
}