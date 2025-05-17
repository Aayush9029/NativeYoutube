import Foundation
import Shared
import Models
import APIClient

@DependencyClient
public struct SearchClient {
    public var searchVideos: (_ query: String, _ apiKey: String) async throws -> [Video] = { _, _ in [] }
}

extension SearchClient: TestDependencyKey {
    public static let previewValue = SearchClient()
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