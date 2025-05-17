import Dependencies
import Foundation
import Models

public struct APIClient {
    public var searchVideos: (SearchRequest) async throws -> [Video]
    public var fetchPlaylistVideos: (PlaylistRequest) async throws -> [Video]
    
    public init(
        searchVideos: @escaping (SearchRequest) async throws -> [Video] = { _ in [] },
        fetchPlaylistVideos: @escaping (PlaylistRequest) async throws -> [Video] = { _ in [] }
    ) {
        self.searchVideos = searchVideos
        self.fetchPlaylistVideos = fetchPlaylistVideos
    }
}

public struct SearchRequest: Equatable {
    public let query: String
    public let apiKey: String
    public let maxResults: Int
    
    public init(query: String, apiKey: String, maxResults: Int = 25) {
        self.query = query
        self.apiKey = apiKey
        self.maxResults = maxResults
    }
}

public struct PlaylistRequest: Equatable {
    public let playlistId: String
    public let apiKey: String
    public let maxResults: Int
    
    public init(playlistId: String, apiKey: String, maxResults: Int = 25) {
        self.playlistId = playlistId
        self.apiKey = apiKey
        self.maxResults = maxResults
    }
}

// Dependency key for swift-dependencies
extension APIClient: DependencyKey {
    public static let liveValue = APIClient(
        searchVideos: { request in
            // Inline the implementation to avoid the linker issue
            let query = request.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&key=\(request.apiKey)&type=video&maxResults=\(request.maxResults)"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                throw URLError(.badServerResponse)
            }
            
            let searchResponse = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
            return searchResponse.items.compactMap { $0.toVideo() }
        },
        fetchPlaylistVideos: { request in
            // Inline the implementation to avoid the linker issue
            let urlString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=\(request.playlistId)&key=\(request.apiKey)&maxResults=\(request.maxResults)"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                throw URLError(.badServerResponse)
            }
            
            let playlistResponse = try JSONDecoder().decode(YouTubePlaylistResponse.self, from: data)
            return playlistResponse.items.map { $0.toVideo() }
        }
    )
    
    public static let previewValue = APIClient()
    public static let testValue = APIClient()
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

