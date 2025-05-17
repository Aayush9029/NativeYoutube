import Testing
import Foundation
@testable import Models

@Suite("Models Tests")
struct ModelsTests {
    
    @Test("YouTube search response decoding works correctly")
    func youTubeSearchResponseDecodingWorksCorrectly() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(YouTubeSearchResponse.self, from: searchData)
        
        #expect(response.items.count == 1)
        #expect(response.items[0].id.videoId == "dQw4w9WgXcQ")
        #expect(response.items[0].snippet.title == "Rick Astley - Never Gonna Give You Up")
        #expect(response.items[0].snippet.channelTitle == "Rick Astley")
        #expect(response.pageInfo.totalResults == 1000000)
        #expect(response.nextPageToken == "CAUQAA")
    }
    
    @Test("YouTube playlist response decoding works correctly")
    func youTubePlaylistResponseDecodingWorksCorrectly() throws {
        let playlistData = MockResponses.playlistResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(YouTubePlaylistResponse.self, from: playlistData)
        
        #expect(response.items.count == 1)
        #expect(response.items[0].contentDetails.videoId == "BL4DCEp7blc")
        #expect(response.items[0].snippet.title == "Building a Better Computer")
        #expect(response.items[0].snippet.channelTitle == "Veritasium")
        #expect(response.pageInfo.totalResults == 200)
        #expect(response.nextPageToken == "CBkQAA")
    }
    
    @Test("Video transform from search item works correctly")
    func videoTransformFromSearchItemWorksCorrectly() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(YouTubeSearchResponse.self, from: searchData)
        let searchItem = response.items[0]
        
        let video = searchItem.toVideo()
        
        #expect(video != nil)
        #expect(video?.id == "dQw4w9WgXcQ")
        #expect(video?.title == "Rick Astley - Never Gonna Give You Up")
        #expect(video?.channelTitle == "Rick Astley")
        #expect(video?.url.absoluteString == "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    }
    
    @Test("Video transform from playlist item works correctly")
    func videoTransformFromPlaylistItemWorksCorrectly() throws {
        let playlistData = MockResponses.playlistResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(YouTubePlaylistResponse.self, from: playlistData)
        let playlistItem = response.items[0]
        
        let video = playlistItem.toVideo()
        
        #expect(video.id == "BL4DCEp7blc")
        #expect(video.title == "Building a Better Computer")
        #expect(video.channelTitle == "Veritasium")
        #expect(video.url.absoluteString == "https://www.youtube.com/watch?v=BL4DCEp7blc")
    }
    
    @Test("Video model is equatable")
    func videoModelIsEquatable() throws {
        let video1 = Video(
            id: "test123",
            title: "Test Video",
            thumbnail: URL(string: "https://example.com/thumb.jpg")!,
            publishedAt: "2023-01-01T00:00:00Z",
            url: URL(string: "https://youtube.com/watch?v=test123")!,
            channelTitle: "Test Channel"
        )
        
        let video2 = Video(
            id: "test123",
            title: "Test Video",
            thumbnail: URL(string: "https://example.com/thumb.jpg")!,
            publishedAt: "2023-01-01T00:00:00Z",
            url: URL(string: "https://youtube.com/watch?v=test123")!,
            channelTitle: "Test Channel"
        )
        
        let video3 = Video(
            id: "different",
            title: "Different Video",
            thumbnail: URL(string: "https://example.com/thumb2.jpg")!,
            publishedAt: "2023-01-02T00:00:00Z",
            url: URL(string: "https://youtube.com/watch?v=different")!,
            channelTitle: "Different Channel"
        )
        
        #expect(video1 == video2)
        #expect(video1 != video3)
    }
    
    @Test("Pages enum works correctly")
    func pagesEnumWorksCorrectly() throws {
        #expect(Pages.allCases.count == 3)
        #expect(Pages.playlists.rawValue == "Playlists")
        #expect(Pages.search.rawValue == "Search")
        #expect(Pages.settings.rawValue == "Settings")
    }
    
    @Test("VideoClickBehaviour enum works correctly")
    func videoClickBehaviourEnumWorksCorrectly() throws {
        #expect(VideoClickBehaviour.allCases.count == 4)
        #expect(VideoClickBehaviour.nothing.rawValue == "Do Nothing")
        #expect(VideoClickBehaviour.playVideo.rawValue == "Play Video")
        #expect(VideoClickBehaviour.openOnYoutube.rawValue == "Open on Youtube")
        #expect(VideoClickBehaviour.playInIINA.rawValue == "Play Using IINA")
    }
    
    @Test("Thumbnail model decoding works correctly")
    func thumbnailDecodingWorksCorrectly() throws {
        let searchData = MockResponses.searchResponse
        let decoder = JSONDecoder()
        
        let response = try decoder.decode(YouTubeSearchResponse.self, from: searchData)
        let thumbnails = response.items[0].snippet.thumbnails
        
        #expect(thumbnails.default?.url == "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg")
        #expect(thumbnails.default?.width == 120)
        #expect(thumbnails.default?.height == 90)
        
        #expect(thumbnails.medium?.url == "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg")
        #expect(thumbnails.medium?.width == 320)
        #expect(thumbnails.medium?.height == 180)
    }
}