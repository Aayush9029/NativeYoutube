import Foundation
import Dependencies
import HTTPTypes
import HTTPTypesFoundation
import Models
import Shared

@DependencyClient
public struct APIClient {
    public var searchVideos: (SearchRequest) async throws -> [Video] = { _ in [] }
    public var fetchPlaylistVideos: (PlaylistRequest) async throws -> [Video] = { _ in [] }
}

public struct SearchRequest: Equatable {
    public let query: String
    public let maxResults: Int
    public let apiKey: String?
    
    public init(query: String, maxResults: Int = 20, apiKey: String? = nil) {
        self.query = query
        self.maxResults = maxResults
        self.apiKey = apiKey
    }
}

public struct PlaylistRequest: Equatable {
    public let playlistId: String
    public let maxResults: Int
    public let apiKey: String?
    
    public init(playlistId: String, maxResults: Int = 50, apiKey: String? = nil) {
        self.playlistId = playlistId
        self.maxResults = maxResults
        self.apiKey = apiKey
    }
}

// Dependency key for swift-dependencies
extension APIClient: TestDependencyKey {
    public static let previewValue = APIClient()
    public static let testValue = APIClient()
}

extension DependencyValues {
    public var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

// Live implementation
extension APIClient {
    public static func live() -> Self {
        APIClient(
            searchVideos: { request in
                try await searchVideosImplementation(request: request)
            },
            fetchPlaylistVideos: { request in
                try await fetchPlaylistVideosImplementation(request: request)
            }
        )
    }
    
    private static func searchVideosImplementation(request: SearchRequest) async throws -> [Video] {
        let apiKey = request.apiKey ?? Constants.defaultAPIKey
        let urlString = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=\(request.query)&key=\(apiKey)&type=video&maxResults=\(request.maxResults)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPRequest.Method.get.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let searchResponse = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
        return searchResponse.items.compactMap { $0.toVideo() }
    }
    
    private static func fetchPlaylistVideosImplementation(request: PlaylistRequest) async throws -> [Video] {
        let apiKey = request.apiKey ?? Constants.defaultAPIKey
        let urlString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=\(request.playlistId)&key=\(apiKey)&maxResults=\(request.maxResults)"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPRequest.Method.get.rawValue
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let playlistResponse = try JSONDecoder().decode(YouTubePlaylistResponse.self, from: data)
        return playlistResponse.items.map { $0.toVideo() }
    }
}

public enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}