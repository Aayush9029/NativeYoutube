import APIClient
import Clients
import CustomDump
import Dependencies
import Foundation
import Models
import Testing

@Suite("SearchClient")
struct SearchClientTests {
    @Test("searchVideos delegates to apiClient.searchVideos")
    func searchDelegation() async throws {
        let expectedVideos = [
            Video(
                id: "s1",
                title: "Search Result",
                thumbnail: URL(string: "https://i.ytimg.com/vi/s1/hqdefault.jpg")!,
                publishedAt: "Today",
                url: URL(string: "https://www.youtube.com/watch?v=s1")!,
                channelTitle: "Channel"
            )
        ]

        var capturedRequest: SearchRequest?

        try await withDependencies {
            $0.apiClient = APIClient(
                searchVideos: { request in
                    capturedRequest = request
                    return expectedVideos
                },
                fetchPlaylistVideos: { _ in [] }
            )
            $0.searchClient = .liveValue
        } operation: {
            @Dependency(\.searchClient) var searchClient
            let results = try await searchClient.searchVideos("SwiftUI", "testApiKey")

            expectNoDifference(results, expectedVideos)
            let request = try #require(capturedRequest)
            #expect(request.query == "SwiftUI")
            #expect(request.apiKey == "testApiKey")
        }
    }

    @Test("searchVideos propagates errors from apiClient")
    func searchErrorPropagation() async {
        await withDependencies {
            $0.apiClient = APIClient(
                searchVideos: { _ in
                    throw APIClientError.httpError(statusCode: 403)
                },
                fetchPlaylistVideos: { _ in [] }
            )
            $0.searchClient = .liveValue
        } operation: {
            @Dependency(\.searchClient) var searchClient
            do {
                _ = try await searchClient.searchVideos("test", "badKey")
                Issue.record("Expected error to be thrown")
            } catch let error as APIClientError {
                #expect(error == .httpError(statusCode: 403))
            } catch {
                Issue.record("Unexpected error type: \(error)")
            }
        }
    }
}
