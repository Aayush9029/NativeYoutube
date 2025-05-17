import Testing
import Dependencies
import SwiftUI
@testable import NativeYoutube
import APIClient
import Clients
import Models
import Shared

@Suite("Integration Tests")
struct IntegrationTests {
    
    @Test("Full search flow works end-to-end")
    @MainActor
    func fullSearchFlowWorks() async throws {
        try await TestConfiguration.withTestDependencies {
            let coordinator = AppCoordinator()
            
            // Navigate to search
            coordinator.navigateTo(.search)
            #expect(coordinator.currentPage == .search)
            
            // Perform search
            await coordinator.search("rick astley")
            
            // Verify results
            #expect(coordinator.searchStatus == .completed)
            #expect(coordinator.searchResults.count == 1)
            #expect(coordinator.searchResults[0].title == "Rick Astley - Never Gonna Give You Up")
            
            // Test video tap
            await coordinator.handleVideoTap(coordinator.searchResults[0])
            
            // Video should have been played (we'd need to mock this to verify)
        }
    }
    
    @Test("Dependencies are properly injected")
    @MainActor
    func dependenciesProperlyInjected() async throws {
        try await TestConfiguration.withTestDependencies {
            let coordinator = AppCoordinator()
            
            // Test search client is injected
            await coordinator.search("test")
            #expect(coordinator.searchResults.count == 1)
            #expect(coordinator.searchResults[0].title == "Test Search Result: test")
        }
    }
    
    @Test("Error states are handled properly")
    @MainActor
    func errorStatesHandledProperly() async throws {
        try await TestConfiguration.withTestDependencies {
            let coordinator = AppCoordinator()
            
            // Search with error query
            await coordinator.search("error")
            
            if case .error = coordinator.searchStatus {
                #expect(true)
            } else {
                Issue.record("Expected error status")
            }
        }
    }
    
    @Test("Live API client can be mocked")
    func liveAPIClientCanBeMocked() async throws {
        let mockClient = APIClient(
            searchVideos: { request in
                [Video(
                    id: "mock-id",
                    title: "Mock Video: \(request.query)",
                    thumbnail: URL(string: "https://example.com/mock.jpg")!,
                    publishedAt: "2023-01-01",
                    url: URL(string: "https://youtube.com/watch?v=mock-id")!,
                    channelTitle: "Mock Channel"
                )]
            },
            fetchPlaylistVideos: { _ in
                []
            }
        )
        
        let searchRequest = SearchRequest(query: "test", apiKey: "test-key")
        let videos = try await mockClient.searchVideos(searchRequest)
        
        #expect(videos.count == 1)
        #expect(videos[0].title == "Mock Video: test")
    }
}