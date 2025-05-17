import Testing
import Foundation
@testable import Models
@testable import APIClient

@Suite("Models Tests")
struct ModelsTests {
    
    @Test("Video model properties work correctly")
    func videoModelPropertiesWorkCorrectly() {
        let video = MockResponses.mockVideo1
        
        #expect(video.id == "dQw4w9WgXcQ")
        #expect(video.title == "Rick Astley - Never Gonna Give You Up")
        #expect(video.channelTitle == "Rick Astley")
        #expect(video.url.absoluteString == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        #expect(video.thumbnail.absoluteString == "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg")
        #expect(video.publishedAt == "2023-01-01T00:00:00Z")
    }
    
    @Test("Video model is equatable")
    func videoModelIsEquatable() {
        let video1 = MockResponses.mockVideo1
        let video2 = MockResponses.mockVideo1
        let video3 = MockResponses.mockVideo2
        
        #expect(video1 == video2)
        #expect(video1 != video3)
    }
    
    @Test("Search request properties work correctly")
    func searchRequestPropertiesWorkCorrectly() {
        let request = MockResponses.mockSearchRequest
        
        #expect(request.query == "SwiftUI Tutorial")
        #expect(request.apiKey == "mock-api-key")
    }
    
    @Test("Playlist request properties work correctly")
    func playlistRequestPropertiesWorkCorrectly() {
        let request = MockResponses.mockPlaylistRequest
        
        #expect(request.playlistId == "PLxxxxxxxx")
        #expect(request.apiKey == "mock-api-key")
    }
    
    @Test("Video collection contains expected items")
    func videoCollectionContainsExpectedItems() {
        let searchResults = MockResponses.searchResults
        let playlistVideos = MockResponses.playlistVideos
        
        #expect(searchResults.count == 3)
        #expect(playlistVideos.count == 3)
        
        #expect(searchResults[0].id == "dQw4w9WgXcQ")
        #expect(searchResults[1].id == "M7lc1UVf-VE")
        #expect(searchResults[2].id == "kJQP7kiw5Fk")
        
        #expect(playlistVideos[0].id == "video1")
        #expect(playlistVideos[1].id == "video2")
        #expect(playlistVideos[2].id == "video3")
    }
}