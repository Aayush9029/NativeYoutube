import Testing
import Foundation
import Dependencies
@testable import NativeYoutube
import APIClient
import Clients
import Models

@Suite("PlaylistClient Tests")
struct PlaylistClientTests {
    
    @Test("Fetch playlist returns valid videos")
    func fetchPlaylistReturnsValidVideos() async throws {
        try await withDependencies {
            $0.playlistClient = PlaylistClient.test
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            let videos = try await playlistClient.fetchVideos("valid-api-key", "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR")
            
            #expect(videos.count == 3)
            #expect(videos[0].title == "SwiftUI Tutorial #1")
            #expect(videos[0].channelTitle == "SwiftUI Academy")
        }
    }
    
    @Test("Fetch playlist with invalid API key throws error")
    func fetchPlaylistWithInvalidAPIKey() async throws {
        try await withDependencies {
            $0.playlistClient = PlaylistClient.test
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            
            await #expect(throws: URLError.self) {
                _ = try await playlistClient.fetchVideos("invalid-api-key", "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR")
            }
        }
    }
    
    @Test("Fetch playlist with error ID throws error")
    func fetchPlaylistWithErrorID() async throws {
        try await withDependencies {
            $0.playlistClient = PlaylistClient.test
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            
            await #expect(throws: URLError.self) {
                _ = try await playlistClient.fetchVideos("valid-api-key", "error")
            }
        }
    }
    
    @Test("Fetch empty playlist returns empty results")
    func fetchEmptyPlaylist() async throws {
        try await withDependencies {
            $0.playlistClient = PlaylistClient.test
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            let videos = try await playlistClient.fetchVideos("valid-api-key", "empty")
            
            #expect(videos.isEmpty)
        }
    }
    
    @Test("Fetch generic playlist returns test results")
    func fetchGenericPlaylist() async throws {
        try await withDependencies {
            $0.playlistClient = PlaylistClient.test
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            let videos = try await playlistClient.fetchVideos("valid-api-key", "generic-playlist")
            
            #expect(videos.count == 1)
            #expect(videos[0].title == "Test Playlist Video")
            #expect(videos[0].channelTitle == "Test Playlist Channel")
        }
    }
    
    @Test("Playlist videos have correct metadata")
    func playlistVideosHaveCorrectMetadata() async throws {
        try await withDependencies {
            $0.playlistClient = PlaylistClient.test
        } operation: {
            @Dependency(\.playlistClient) var playlistClient
            let videos = try await playlistClient.fetchVideos("valid-api-key", "PLGhj5ta_lcE7EFJ0D4tPyPFtHAWT9h9iR")
            
            // Check first video
            #expect(videos[0].url.absoluteString == "https://www.youtube.com/watch?v=video1")
            #expect(videos[0].thumbnail.absoluteString == "https://i.ytimg.com/vi/video1/default.jpg")
            
            // Check second video has different owner
            #expect(videos[1].title == "SwiftUI Tutorial #2")
            #expect(videos[1].channelTitle == "SwiftUI Academy")
            
            // Check third video
            #expect(videos[2].title == "SwiftUI Tutorial #3")
            #expect(videos[2].channelTitle == "SwiftUI Academy")
        }
    }
}