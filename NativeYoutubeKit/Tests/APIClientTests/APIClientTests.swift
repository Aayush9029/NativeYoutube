import APIClient
import CustomDump
import Dependencies
import Foundation
import Models
import Testing

@Suite("APIClient")
struct APIClientTests {
    @Test("SearchRequest equality")
    func searchRequestEquality() {
        let a = SearchRequest(query: "swift", apiKey: "key1", maxResults: 10)
        let b = SearchRequest(query: "swift", apiKey: "key1", maxResults: 10)
        let c = SearchRequest(query: "kotlin", apiKey: "key1", maxResults: 10)

        #expect(a == b)
        #expect(a != c)
    }

    @Test("SearchRequest default maxResults is 25")
    func searchRequestDefaults() {
        let request = SearchRequest(query: "test", apiKey: "key")
        #expect(request.maxResults == 25)
    }

    @Test("PlaylistRequest equality")
    func playlistRequestEquality() {
        let a = PlaylistRequest(playlistId: "PL123", apiKey: "key1")
        let b = PlaylistRequest(playlistId: "PL123", apiKey: "key1")
        let c = PlaylistRequest(playlistId: "PL456", apiKey: "key1")

        #expect(a == b)
        #expect(a != c)
    }

    @Test("PlaylistRequest default maxResults is 25")
    func playlistRequestDefaults() {
        let request = PlaylistRequest(playlistId: "PL1", apiKey: "key")
        #expect(request.maxResults == 25)
    }

    @Test("Mock client returns fixture data for search")
    func mockClientSearch() async throws {
        let expectedVideos = [
            Video(
                id: "v1",
                title: "Mock Video",
                thumbnail: URL(string: "https://i.ytimg.com/vi/v1/hqdefault.jpg")!,
                publishedAt: "Today",
                url: URL(string: "https://www.youtube.com/watch?v=v1")!,
                channelTitle: "Mock Channel"
            )
        ]

        let client = APIClient(
            searchVideos: { _ in expectedVideos },
            fetchPlaylistVideos: { _ in [] }
        )

        let results = try await client.searchVideos(SearchRequest(query: "test", apiKey: "key"))
        expectNoDifference(results, expectedVideos)
    }

    @Test("Mock client returns fixture data for playlist")
    func mockClientPlaylist() async throws {
        let expectedVideos = [
            Video(
                id: "p1",
                title: "Playlist Video",
                thumbnail: URL(string: "https://i.ytimg.com/vi/p1/hqdefault.jpg")!,
                publishedAt: "Yesterday",
                url: URL(string: "https://www.youtube.com/watch?v=p1")!,
                channelTitle: "Playlist Channel"
            )
        ]

        let client = APIClient(
            searchVideos: { _ in [] },
            fetchPlaylistVideos: { _ in expectedVideos }
        )

        let results = try await client.fetchPlaylistVideos(PlaylistRequest(playlistId: "PL1", apiKey: "key"))
        expectNoDifference(results, expectedVideos)
    }

    @Test("APIClientError has proper descriptions")
    func errorDescriptions() {
        let invalidURL = APIClientError.invalidURL("bad://url")
        #expect(invalidURL.localizedDescription.contains("Invalid URL"))

        let httpError = APIClientError.httpError(statusCode: 403)
        #expect(httpError.localizedDescription.contains("403"))

        let decodingError = APIClientError.decodingError("missing key")
        #expect(decodingError.localizedDescription.contains("missing key"))
    }

    @Test("APIClientError is Equatable")
    func errorEquatable() {
        #expect(APIClientError.httpError(statusCode: 404) == APIClientError.httpError(statusCode: 404))
        #expect(APIClientError.httpError(statusCode: 404) != APIClientError.httpError(statusCode: 500))
        #expect(APIClientError.invalidURL("a") == APIClientError.invalidURL("a"))
    }

    @Test("previewValue returns empty arrays")
    func previewValueReturnsEmpty() async throws {
        let client = APIClient.previewValue
        let searchResults = try await client.searchVideos(SearchRequest(query: "test", apiKey: "key"))
        #expect(searchResults.isEmpty)
        let playlistResults = try await client.fetchPlaylistVideos(PlaylistRequest(playlistId: "PL1", apiKey: "key"))
        #expect(playlistResults.isEmpty)
    }
}
