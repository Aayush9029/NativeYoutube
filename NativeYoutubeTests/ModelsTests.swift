import Testing
import Foundation
@testable import Models
@testable import APIClient

@Suite("Models Tests")
struct ModelsTests {
    
    @Test("Search response decoding works correctly")
    func searchResponseDecodingWorksCorrectly() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(SearchResponse.self, from: searchData)
        
        #expect(response.items.count == 1)
        #expect(response.items[0].id.videoId == "dQw4w9WgXcQ")
        #expect(response.items[0].snippet.title == "Rick Astley - Never Gonna Give You Up")
        #expect(response.items[0].snippet.channelTitle == "Rick Astley")
        #expect(response.pageInfo.totalResults == 1000000)
        #expect(response.nextPageToken == "CAUQAA")
    }
    
    @Test("Playlist response decoding works correctly")
    func playlistResponseDecodingWorksCorrectly() throws {
        let playlistData = MockResponses.playlistResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(PlaylistResponse.self, from: playlistData)
        
        #expect(response.items.count == 1)
        #expect(response.items[0].snippet.resourceId.videoId == "BL4DCEp7blc")
        #expect(response.items[0].snippet.title == "Building a Better Computer")
        #expect(response.items[0].snippet.channelTitle == "Veritasium")
        #expect(response.pageInfo.totalResults == 200)
        #expect(response.nextPageToken == "CBkQAA")
    }
    
    @Test("Video transform from search result works correctly")
    func videoTransformFromSearchResultWorksCorrectly() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(SearchResponse.self, from: searchData)
        let searchResult = response.items[0]
        
        let video = Video.from(searchResult: searchResult)
        
        #expect(video.id == "dQw4w9WgXcQ")
        #expect(video.title == "Rick Astley - Never Gonna Give You Up")
        #expect(video.channelTitle == "Rick Astley")
        #expect(video.url.absoluteString == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        #expect(video.thumbnail.absoluteString == "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg")
    }
    
    @Test("Video transform from playlist item works correctly")
    func videoTransformFromPlaylistItemWorksCorrectly() throws {
        let playlistData = MockResponses.playlistResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(PlaylistResponse.self, from: playlistData)
        let playlistItem = response.items[0]
        
        let video = Video.from(playlistItem: playlistItem)
        
        #expect(video.id == "BL4DCEp7blc")
        #expect(video.title == "Building a Better Computer")
        #expect(video.channelTitle == "Veritasium")
        #expect(video.url.absoluteString == "https://www.youtube.com/watch?v=BL4DCEp7blc")
        #expect(video.thumbnail.absoluteString == "https://i.ytimg.com/vi/BL4DCEp7blc/default.jpg")
    }
    
    @Test("Video model is equatable")
    func videoModelIsEquatable() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: searchData)
        
        let video1 = Video.from(searchResult: response.items[0])
        let video2 = Video.from(searchResult: response.items[0])
        
        #expect(video1 == video2)
        #expect(video1.id == video2.id)
    }
    
    @Test("Pages model works correctly")
    func pagesModelWorksCorrectly() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: searchData)
        
        let pages = Pages<Video>(items: [Video.from(searchResult: response.items[0])])
        
        #expect(pages.items.count == 1)
        #expect(pages.items[0].id == "dQw4w9WgXcQ")
    }
}