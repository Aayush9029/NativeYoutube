import APIClient
import Clients
import Dependencies
import Foundation
import Models

// Test implementation for APIClient
extension APIClient {
    static let test = APIClient(
        searchVideos: { request in
            guard request.apiKey == "valid-api-key" else {
                throw URLError(.userAuthenticationRequired)
            }

            switch request.query.lowercased() {
            case "rick astley":
                return [MockResponses.mockVideo1, MockResponses.mockVideo2, MockResponses.mockVideo3]
            case "error":
                throw URLError(.badServerResponse)
            case "empty":
                return []
            default:
                return [
                    Video(
                        id: "test-video-1",
                        title: "Test Search Result: \(request.query)",
                        thumbnail: URL(string: "https://i.ytimg.com/vi/test-video-1/hqdefault.jpg")!,
                        publishedAt: "2023-01-01T00:00:00Z",
                        url: URL(string: "https://www.youtube.com/watch?v=test-video-1")!,
                        channelTitle: "Test Channel"
                    )
                ]
            }
        },
        fetchPlaylistVideos: { request in
            guard request.apiKey == "valid-api-key" else {
                throw URLError(.userAuthenticationRequired)
            }

            switch request.playlistId {
            case "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR":
                return MockResponses.playlistVideos
            case "error":
                throw URLError(.badServerResponse)
            case "empty":
                return []
            default:
                return [
                    Video(
                        id: "playlist-video-1",
                        title: "Test Playlist Video",
                        thumbnail: URL(string: "https://i.ytimg.com/vi/playlist-video-1/hqdefault.jpg")!,
                        publishedAt: "2023-01-01T00:00:00Z",
                        url: URL(string: "https://www.youtube.com/watch?v=playlist-video-1")!,
                        channelTitle: "Test Playlist Channel"
                    )
                ]
            }
        }
    )
}

// Test implementation for SearchClient
extension SearchClient {
    static let test = SearchClient(
        searchVideos: { query, apiKey in
            let request = SearchRequest(query: query, apiKey: apiKey)
            return try await APIClient.test.searchVideos(request)
        }
    )
}

// Test implementation for PlaylistClient
extension PlaylistClient {
    static let test = PlaylistClient(
        fetchVideos: { apiKey, playlistId in
            let request = PlaylistRequest(playlistId: playlistId, apiKey: apiKey)
            return try await APIClient.test.fetchPlaylistVideos(request)
        }
    )
}
