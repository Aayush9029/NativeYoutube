import APIClient
import Foundation
import Models
import Testing

@Suite("YouTube API Integration", .enabled(if: TestConfig.youtubeAPIKey != nil))
struct YouTubeAPIIntegrationTests {
    var apiKey: String { TestConfig.youtubeAPIKey! }
    let client = APIClient.liveValue

    @Test("Search returns results for a common query")
    func searchReturnsResults() async throws {
        let request = SearchRequest(query: "SwiftUI", apiKey: apiKey, maxResults: 5)
        let videos = try await client.searchVideos(request)

        #expect(!videos.isEmpty)
        for video in videos {
            #expect(!video.id.isEmpty)
            #expect(!video.title.isEmpty)
            #expect(video.url.absoluteString.contains("youtube.com/watch"))
        }
    }

    @Test("Search maxResults is respected")
    func searchMaxResultsRespected() async throws {
        let request = SearchRequest(query: "Swift programming", apiKey: apiKey, maxResults: 2)
        let videos = try await client.searchVideos(request)

        #expect(videos.count <= 2)
    }

    @Test("Search with invalid API key throws an error")
    func searchInvalidAPIKeyThrows() async {
        let request = SearchRequest(query: "test", apiKey: "INVALID_KEY_12345", maxResults: 1)
        do {
            _ = try await client.searchVideos(request)
            Issue.record("Expected error for invalid API key")
        } catch let error as APIClientError {
            if case .httpError(let statusCode) = error {
                #expect(statusCode == 400 || statusCode == 403)
            } else {
                Issue.record("Expected httpError, got: \(error)")
            }
        } catch {
            // Any error is acceptable for an invalid key
        }
    }

    @Test("Fetch playlist returns videos")
    func fetchPlaylistReturnsVideos() async throws {
        let request = PlaylistRequest(
            playlistId: TestConfig.defaultPlaylistID,
            apiKey: apiKey,
            maxResults: 5
        )
        let videos = try await client.fetchPlaylistVideos(request)

        #expect(!videos.isEmpty)
        for video in videos {
            #expect(!video.id.isEmpty)
            #expect(!video.title.isEmpty)
        }
    }

    @Test("Search thumbnail URLs are valid ytimg.com URLs")
    func searchThumbnailURLsValid() async throws {
        let request = SearchRequest(query: "macOS development", apiKey: apiKey, maxResults: 3)
        let videos = try await client.searchVideos(request)

        for video in videos {
            let thumbnailString = video.thumbnail.absoluteString
            #expect(thumbnailString.hasPrefix("https://"))
            #expect(thumbnailString.contains("ytimg.com") || thumbnailString.contains("placeholder"))
        }
    }

    @Test("Fetch invalid playlist ID is handled")
    func fetchInvalidPlaylistHandled() async {
        let request = PlaylistRequest(
            playlistId: "PLthisplaylistdoesnotexist999",
            apiKey: apiKey,
            maxResults: 5
        )
        do {
            _ = try await client.fetchPlaylistVideos(request)
            Issue.record("Expected error for invalid playlist")
        } catch {
            // Any error is acceptable - invalid playlist should fail
        }
    }
}
