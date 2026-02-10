import Dependencies
import DependenciesMacros
import Foundation
import IdentifiedCollections
import Models

public enum APIClientError: LocalizedError, Equatable {
    case invalidURL(String)
    case httpError(statusCode: Int)
    case decodingError(String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid URL: \(url)"
        case .httpError(statusCode: let code):
            return "HTTP error: \(code)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        }
    }
}

@DependencyClient
public struct APIClient {
    public var searchVideos: (_ request: SearchRequest) async throws -> IdentifiedArrayOf<Video>
    public var fetchPlaylistVideos: (_ request: PlaylistRequest) async throws -> IdentifiedArrayOf<Video>
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

extension APIClient: DependencyKey {
    public static var liveValue = APIClient(
        searchVideos: { request in
            let query = request.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&q=\(query)&key=\(request.apiKey)&type=video&maxResults=\(request.maxResults)"

            guard let url = URL(string: urlString) else {
                throw APIClientError.invalidURL(urlString)
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.httpError(statusCode: 0)
            }

            guard httpResponse.statusCode == 200 else {
                throw APIClientError.httpError(statusCode: httpResponse.statusCode)
            }

            do {
                let searchResponse = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                return IdentifiedArray(uniqueElements: searchResponse.items.compactMap { $0.toVideo() })
            } catch let error as DecodingError {
                throw APIClientError.decodingError(String(describing: error))
            }
        },
        fetchPlaylistVideos: { request in
            let urlString = "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=\(request.playlistId)&key=\(request.apiKey)&maxResults=\(request.maxResults)"

            guard let url = URL(string: urlString) else {
                throw APIClientError.invalidURL(urlString)
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIClientError.httpError(statusCode: 0)
            }

            guard httpResponse.statusCode == 200 else {
                throw APIClientError.httpError(statusCode: httpResponse.statusCode)
            }

            do {
                let playlistResponse = try JSONDecoder().decode(YouTubePlaylistResponse.self, from: data)
                return IdentifiedArray(uniqueElements: playlistResponse.items.map { $0.toVideo() })
            } catch let error as DecodingError {
                throw APIClientError.decodingError(String(describing: error))
            }
        }
    )

    public static var previewValue = APIClient(
        searchVideos: { _ in [] },
        fetchPlaylistVideos: { _ in [] }
    )
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
