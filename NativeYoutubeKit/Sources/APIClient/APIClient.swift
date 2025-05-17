import Foundation
import Dependencies
import Models
import Shared

@DependencyClient
public struct APIClient {
    public var searchVideos: (SearchRequest) async throws -> [Video] = { _ in [] }
    public var fetchPlaylistVideos: (PlaylistRequest) async throws -> [Video] = { _ in [] }
}

// Base protocol for all API requests
public protocol YouTubeAPIRequest {
    var apiKey: String? { get }
    var maxResults: Int { get }
}

public struct SearchRequest: YouTubeAPIRequest, Equatable {
    public let query: String
    public let maxResults: Int
    public let apiKey: String?
    
    public init(query: String, maxResults: Int = 20, apiKey: String? = nil) {
        self.query = query
        self.maxResults = maxResults
        self.apiKey = apiKey
    }
}

public struct PlaylistRequest: YouTubeAPIRequest, Equatable {
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
                guard let apiKey = request.apiKey else {
                    throw APIError.missingAPIKey
                }
                
                let endpoint = YouTubeEndpoint.search(
                    query: request.query,
                    maxResults: request.maxResults,
                    apiKey: apiKey
                )
                
                let response: YouTubeSearchResponse = try await performRequest(for: endpoint)
                return response.items.compactMap { $0.toVideo() }
            },
            fetchPlaylistVideos: { request in
                guard let apiKey = request.apiKey else {
                    throw APIError.missingAPIKey
                }
                
                let endpoint = YouTubeEndpoint.playlistItems(
                    playlistId: request.playlistId,
                    maxResults: request.maxResults,
                    apiKey: apiKey
                )
                
                let response: YouTubePlaylistResponse = try await performRequest(for: endpoint)
                return response.items.map { $0.toVideo() }
            }
        )
    }
    
    private static func performRequest<T: Decodable>(for endpoint: YouTubeEndpoint) async throws -> T {
        let url = try endpoint.url()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

public enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case missingAPIKey
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .missingAPIKey:
            return "API key is missing"
        }
    }
}

// YouTube API Endpoints
private enum YouTubeEndpoint {
    case search(query: String, maxResults: Int, apiKey: String)
    case playlistItems(playlistId: String, maxResults: Int, apiKey: String)
    
    private var baseURL: String {
        "https://youtube.googleapis.com/youtube/v3"
    }
    
    private var path: String {
        switch self {
        case .search:
            return "/search"
        case .playlistItems:
            return "/playlistItems"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .search(let query, let maxResults, let apiKey):
            return [
                URLQueryItem(name: "part", value: "snippet"),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "type", value: "video"),
                URLQueryItem(name: "maxResults", value: String(maxResults))
            ]
        case .playlistItems(let playlistId, let maxResults, let apiKey):
            return [
                URLQueryItem(name: "part", value: "snippet,contentDetails,status"),
                URLQueryItem(name: "playlistId", value: playlistId),
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "maxResults", value: String(maxResults))
            ]
        }
    }
    
    func url() throws -> URL {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        return url
    }
}