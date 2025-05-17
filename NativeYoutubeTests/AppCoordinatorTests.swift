import Testing
import Dependencies
import SwiftUI
@testable import NativeYoutube
import Models
import APIClient
import Clients
import Shared

@Suite("AppCoordinator Tests")
struct AppCoordinatorTests {
    
    @Test("Initial state is correct")
    @MainActor
    func initialStateIsCorrect() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            let coordinator = AppCoordinator()
            
            #expect(coordinator.currentPage == .playlists)
            #expect(coordinator.searchQuery == "")
            #expect(coordinator.searchResults.isEmpty)
            #expect(coordinator.searchStatus == .idle)
            #expect(coordinator.playlistVideos.isEmpty)
            #expect(coordinator.selectedPlaylist == "")
            #expect(coordinator.showingVideoPlayer == false)
            #expect(coordinator.currentVideoURL == nil)
            #expect(coordinator.currentVideoTitle == "")
        }
    }
    
    @Test("Navigation changes current page")
    @MainActor
    func navigationChangesCurrentPage() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            let coordinator = AppCoordinator()
            
            coordinator.navigateTo(.search)
            #expect(coordinator.currentPage == .search)
            
            coordinator.navigateTo(.settings)
            #expect(coordinator.currentPage == .settings)
            
            coordinator.navigateTo(.playlists)
            #expect(coordinator.currentPage == .playlists)
        }
    }
    
    @Test("Search updates status correctly")
    @MainActor
    func searchUpdatesStatusCorrectly() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            let coordinator = AppCoordinator()
            
            await coordinator.search("rick astley")
            
            #expect(coordinator.searchQuery == "rick astley")
            #expect(coordinator.searchStatus == .completed)
            #expect(coordinator.searchResults.count == 1)
            #expect(coordinator.searchResults[0].title == "Rick Astley - Never Gonna Give You Up")
        }
    }
    
    @Test("Search with empty query does nothing")
    @MainActor
    func searchWithEmptyQueryDoesNothing() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            let coordinator = AppCoordinator()
            
            await coordinator.search("")
            
            #expect(coordinator.searchStatus == .idle)
            #expect(coordinator.searchResults.isEmpty)
        }
    }
    
    @Test("Search handles errors correctly")
    @MainActor
    func searchHandlesErrors() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            let coordinator = AppCoordinator()
            
            await coordinator.search("error")
            
            #expect(coordinator.searchStatus == .error("The operation couldn't be completed. (NSURLErrorDomain error -1011.)"))
        }
    }
    
    @Test("Load playlist updates status correctly")
    @MainActor
    func loadPlaylistUpdatesStatusCorrectly() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            @Shared(.apiKey) var apiKey
            @Shared(.playlistID) var playlistID
            
            $apiKey.withLock { $0 = "valid-api-key" }
            $playlistID.withLock { $0 = "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR" }
            
            let coordinator = AppCoordinator()
            
            await coordinator.loadPlaylist()
            
            #expect(coordinator.playlistStatus == .completed)
            #expect(coordinator.playlistVideos.count == 3)
            #expect(coordinator.selectedPlaylist == "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR")
        }
    }
    
    @Test("Load playlist handles errors correctly")
    @MainActor
    func loadPlaylistHandlesErrors() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            @Shared(.apiKey) var apiKey
            @Shared(.playlistID) var playlistID
            
            $apiKey.withLock { $0 = "valid-api-key" }
            $playlistID.withLock { $0 = "error" }
            
            let coordinator = AppCoordinator()
            
            await coordinator.loadPlaylist()
            
            #expect(coordinator.playlistStatus == .error("The operation couldn't be completed. (NSURLErrorDomain error -1011.)"))
        }
    }
    
    @Test("Handle video tap triggers correct action")
    @MainActor
    func handleVideoTapTriggersCorrectAction() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            @Shared(.videoClickBehaviour) var videoClickBehaviour
            
            $videoClickBehaviour.withLock { $0 = .playVideo }
            
            let coordinator = AppCoordinator()
            let testVideo = Video(
                id: "test",
                title: "Test Video",
                thumbnail: URL(string: "https://example.com/thumb.jpg")!,
                publishedAt: "2023-01-01T00:00:00Z",
                url: URL(string: "https://www.youtube.com/watch?v=test")!,
                channelTitle: "Test Channel"
            )
            
            await coordinator.handleVideoTap(testVideo)
            
            // This would normally trigger the app state client
            // In a real test, we'd verify the app state client was called
        }
    }
    
    @Test("Hide video player clears state")
    @MainActor
    func hideVideoPlayerClearsState() async throws {
        await withDependencies {
            $0.searchClient = SearchClient.test
            $0.playlistClient = PlaylistClient.test
            $0.appStateClient = AppStateClient.test
        } operation: {
            let coordinator = AppCoordinator()
            
            // Test showVideoInApp directly
            let testURL = URL(string: "https://www.youtube.com/watch?v=test")!
            coordinator.showVideoInApp(testURL, "Test Video")
            
            // Verify state is set
            #expect(coordinator.showingVideoPlayer == true)
            #expect(coordinator.currentVideoURL == testURL)
            #expect(coordinator.currentVideoTitle == "Test Video")
            
            // Hide video player
            coordinator.hideVideoPlayer()
            
            // Verify state is cleared
            #expect(coordinator.showingVideoPlayer == false)
            #expect(coordinator.currentVideoURL == nil)
            #expect(coordinator.currentVideoTitle == "")
        }
    }
}