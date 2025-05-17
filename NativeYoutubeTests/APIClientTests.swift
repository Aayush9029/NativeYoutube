import Testing
import Foundation
import Dependencies
@testable import APIClient
import Models

@Suite("APIClient Tests")
struct APIClientTests {
    
    @Test("Search videos API returns expected results")
    func searchVideosReturnsExpectedResults() async throws {
        let apiClient = APIClient.test
        let request = SearchRequest(query: "rick astley", apiKey: "valid-api-key")
        let videos = try await apiClient.searchVideos(request)
        
        #expect(videos.count == 3)
        #expect(videos[0].id == "dQw4w9WgXcQ")
        #expect(videos[0].title == "Rick Astley - Never Gonna Give You Up")
        #expect(videos[0].channelTitle == "Rick Astley")
    }
    
    @Test("Search videos with error query throws error")
    func searchVideosWithErrorQuery() async throws {
        let apiClient = APIClient.test
        let request = SearchRequest(query: "error", apiKey: "valid-api-key")
        
        await #expect(throws: URLError.self) {
            _ = try await apiClient.searchVideos(request)
        }
    }
    
    @Test("Search videos with invalid API key throws error")
    func searchVideosWithInvalidAPIKey() async throws {
        let apiClient = APIClient.test
        let request = SearchRequest(query: "test", apiKey: "invalid-key")
        
        await #expect(throws: URLError.self) {
            _ = try await apiClient.searchVideos(request)
        }
    }
    
    @Test("Fetch playlist videos returns expected results")
    func fetchPlaylistVideosReturnsExpectedResults() async throws {
        let apiClient = APIClient.test
        let request = PlaylistRequest(playlistId: "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR", apiKey: "valid-api-key")
        let videos = try await apiClient.fetchPlaylistVideos(request)
        
        #expect(videos.count == 3)
        #expect(videos[0].id == "aP-SQXTtWhY")
        #expect(videos[0].title == "SwiftUI Tutorial - Building a Complete App")
        #expect(videos[0].channelTitle == "Google Developers")
    }
    
    @Test("Fetch playlist with error ID throws error")
    func fetchPlaylistWithErrorID() async throws {
        let apiClient = APIClient.test
        let request = PlaylistRequest(playlistId: "error", apiKey: "valid-api-key")
        
        await #expect(throws: URLError.self) {
            _ = try await apiClient.fetchPlaylistVideos(request)
        }
    }
    
    @Test("Fetch playlist with invalid API key throws error")
    func fetchPlaylistWithInvalidAPIKey() async throws {
        let apiClient = APIClient.test
        let request = PlaylistRequest(playlistId: "test", apiKey: "invalid-key")
        
        await #expect(throws: URLError.self) {
            _ = try await apiClient.fetchPlaylistVideos(request)
        }
    }
    
    @Test("API client transforms YouTube responses correctly")
    func apiClientTransformsResponsesCorrectly() async throws {
        let apiClient = APIClient.test
        let searchRequest = SearchRequest(query: "rick astley", apiKey: "valid-api-key")
        let searchVideos = try await apiClient.searchVideos(searchRequest)
        
        // Test video transformation
        let firstVideo = searchVideos[0]
        #expect(firstVideo.url.absoluteString == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        #expect(firstVideo.thumbnail.absoluteString == "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg")
        
        // Test date transformation  
        #expect(!firstVideo.publishedAt.isEmpty)
    }
    
    @Test("Empty results are handled correctly")
    func emptyResultsHandledCorrectly() async throws {
        let apiClient = APIClient.test
        
        // Test empty search
        let searchRequest = SearchRequest(query: "empty", apiKey: "valid-api-key")
        let searchVideos = try await apiClient.searchVideos(searchRequest)
        #expect(searchVideos.isEmpty)
        
        // Test empty playlist
        let playlistRequest = PlaylistRequest(playlistId: "empty", apiKey: "valid-api-key")
        let playlistVideos = try await apiClient.fetchPlaylistVideos(playlistRequest)
        #expect(playlistVideos.isEmpty)
    }
}