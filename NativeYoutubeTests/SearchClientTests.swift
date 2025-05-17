import Testing
import Foundation
import Dependencies
@testable import NativeYoutube
import APIClient
import Clients
import Models

@Suite("SearchClient Tests")
struct SearchClientTests {
    
    @Test("Search returns valid results")
    func searchReturnsValidResults() async throws {
        try await withDependencies {
            $0.searchClient = SearchClient.test
        } operation: {
            @Dependency(\.searchClient) var searchClient
            let videos = try await searchClient.searchVideos("rick astley", "valid-api-key")
            
            #expect(videos.count == 1)
            #expect(videos[0].title == "Rick Astley - Never Gonna Give You Up")
            #expect(videos[0].channelTitle == "Rick Astley")
            #expect(videos[0].id == "dQw4w9WgXcQ")
        }
    }
    
    @Test("Search with invalid API key throws error")
    func searchWithInvalidAPIKey() async throws {
        try await withDependencies {
            $0.searchClient = SearchClient.test
        } operation: {
            @Dependency(\.searchClient) var searchClient
            
            await #expect(throws: URLError.self) {
                _ = try await searchClient.searchVideos("test", "invalid-api-key")
            }
        }
    }
    
    @Test("Search with error query throws error")
    func searchWithErrorQuery() async throws {
        try await withDependencies {
            $0.searchClient = SearchClient.test
        } operation: {
            @Dependency(\.searchClient) var searchClient
            
            await #expect(throws: URLError.self) {
                _ = try await searchClient.searchVideos("error", "valid-api-key")
            }
        }
    }
    
    @Test("Search with empty query returns empty results")
    func searchWithEmptyQuery() async throws {
        try await withDependencies {
            $0.searchClient = SearchClient.test
        } operation: {
            @Dependency(\.searchClient) var searchClient
            let videos = try await searchClient.searchVideos("empty", "valid-api-key")
            
            #expect(videos.isEmpty)
        }
    }
    
    @Test("Search with generic query returns test results")
    func searchWithGenericQuery() async throws {
        try await withDependencies {
            $0.searchClient = SearchClient.test
        } operation: {
            @Dependency(\.searchClient) var searchClient
            let videos = try await searchClient.searchVideos("SwiftUI Tutorial", "valid-api-key")
            
            #expect(videos.count == 1)
            #expect(videos[0].title == "Test Search Result: SwiftUI Tutorial")
            #expect(videos[0].channelTitle == "Test Channel")
        }
    }
    
    @Test("Search results have proper video URLs")
    func searchResultsHaveProperURLs() async throws {
        try await withDependencies {
            $0.searchClient = SearchClient.test
        } operation: {
            @Dependency(\.searchClient) var searchClient
            let videos = try await searchClient.searchVideos("rick astley", "valid-api-key")
            
            #expect(videos[0].url.absoluteString == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
            #expect(videos[0].thumbnail.absoluteString == "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg")
        }
    }
}