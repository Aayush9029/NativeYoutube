import APIClient
import Clients
import CustomDump
import Dependencies
import DependenciesTestSupport
import Foundation
import IdentifiedCollections
import Models
import Testing

@Suite("PlaylistClient")
struct PlaylistClientTests {
    @Test("fetchVideos delegates to apiClient.fetchPlaylistVideos")
    func fetchDelegation() async throws {
        let expectedVideos: IdentifiedArrayOf<Video> = [
            Video(
                id: "p1",
                title: "Playlist Video",
                thumbnail: URL(string: "https://i.ytimg.com/vi/p1/hqdefault.jpg")!,
                publishedAt: "Today",
                url: URL(string: "https://www.youtube.com/watch?v=p1")!,
                channelTitle: "Creator"
            )
        ]

        var capturedRequest: PlaylistRequest?

        try await withDependencies {
            $0.apiClient = APIClient(
                searchVideos: { _ in [] },
                fetchPlaylistVideos: { request in
                    capturedRequest = request
                    return expectedVideos
                }
            )
            $0.playlistClient = .liveValue
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            let results = try await playlistClient.fetchVideos("testApiKey", "PLtest123")

            expectNoDifference(results, expectedVideos)
            let request = try #require(capturedRequest)
            #expect(request.playlistId == "PLtest123")
            #expect(request.apiKey == "testApiKey")
        }
    }

    @Test(
        "fetchVideos propagates errors from apiClient",
        .dependencies {
            $0.apiClient = APIClient(
                searchVideos: { _ in [] },
                fetchPlaylistVideos: { _ in
                    throw APIClientError.httpError(statusCode: 404)
                }
            )
            $0.playlistClient = .liveValue
        }
    )
    func fetchErrorPropagation() async {
        @Dependency(\.playlistClient) var playlistClient
        do {
            _ = try await playlistClient.fetchVideos("key", "badPlaylist")
            Issue.record("Expected error to be thrown")
        } catch let error as APIClientError {
            #expect(error == .httpError(statusCode: 404))
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
