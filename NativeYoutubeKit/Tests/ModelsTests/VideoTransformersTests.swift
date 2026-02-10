import Foundation
import Models
import Testing

@Suite("Video Transformers")
struct VideoTransformersTests {
    @Test("SearchItem.toVideo() returns Video for valid videoId")
    func searchItemToVideoHappyPath() throws {
        let json = """
        {
            "kind": "youtube#searchResult",
            "etag": "etag123",
            "id": {
                "kind": "youtube#video",
                "videoId": "abc123"
            },
            "snippet": {
                "publishedAt": "2024-01-15T10:00:00Z",
                "channelId": "UCtest",
                "title": "Test Search Video",
                "description": "A test video",
                "thumbnails": {
                    "default": { "url": "https://i.ytimg.com/vi/abc123/default.jpg", "width": 120, "height": 90 },
                    "medium": { "url": "https://i.ytimg.com/vi/abc123/mqdefault.jpg", "width": 320, "height": 180 },
                    "high": { "url": "https://i.ytimg.com/vi/abc123/hqdefault.jpg", "width": 480, "height": 360 }
                },
                "channelTitle": "Test Channel",
                "liveBroadcastContent": "none"
            }
        }
        """

        let item = try JSONDecoder().decode(SearchItem.self, from: json.data(using: .utf8)!)
        let video = item.toVideo()
        #expect(video != nil)
        #expect(video?.id == "abc123")
        #expect(video?.title == "Test Search Video")
        #expect(video?.channelTitle == "Test Channel")
        #expect(video?.url == URL(string: "https://www.youtube.com/watch?v=abc123"))
        #expect(video?.thumbnail == URL(string: "https://i.ytimg.com/vi/abc123/mqdefault.jpg"))
    }

    @Test("SearchItem.toVideo() returns nil when videoId is nil")
    func searchItemToVideoNilVideoId() throws {
        let json = """
        {
            "kind": "youtube#searchResult",
            "etag": "etag",
            "id": {
                "kind": "youtube#channel",
                "channelId": "UCtest"
            },
            "snippet": {
                "publishedAt": "2024-01-15T10:00:00Z",
                "channelId": "UCtest",
                "title": "Channel Result",
                "description": "",
                "thumbnails": {},
                "channelTitle": "Test",
                "liveBroadcastContent": "none"
            }
        }
        """

        let item = try JSONDecoder().decode(SearchItem.self, from: json.data(using: .utf8)!)
        #expect(item.toVideo() == nil)
    }

    @Test("PlaylistItem.toVideo() uses videoOwnerChannelTitle when available")
    func playlistItemToVideoWithOwnerTitle() throws {
        let json = """
        {
            "kind": "youtube#playlistItem",
            "etag": "etag",
            "id": "playlistItem1",
            "snippet": {
                "publishedAt": "2024-01-15T10:00:00Z",
                "channelId": "UCplaylist",
                "title": "Playlist Video",
                "description": "desc",
                "thumbnails": {
                    "medium": { "url": "https://i.ytimg.com/vi/vid1/mqdefault.jpg", "width": 320, "height": 180 }
                },
                "channelTitle": "Playlist Owner",
                "playlistId": "PL123",
                "position": 0,
                "resourceId": { "kind": "youtube#video", "videoId": "vid1" },
                "videoOwnerChannelTitle": "Video Creator",
                "videoOwnerChannelId": "UCcreator"
            },
            "contentDetails": {
                "videoId": "vid1",
                "videoPublishedAt": "2024-01-10T08:00:00Z"
            }
        }
        """

        let item = try JSONDecoder().decode(PlaylistItem.self, from: json.data(using: .utf8)!)
        let video = item.toVideo()
        #expect(video.id == "vid1")
        #expect(video.channelTitle == "Video Creator")
        #expect(video.url == URL(string: "https://www.youtube.com/watch?v=vid1"))
    }

    @Test("PlaylistItem.toVideo() falls back to channelTitle when videoOwnerChannelTitle is nil")
    func playlistItemToVideoFallbackChannelTitle() throws {
        let json = """
        {
            "kind": "youtube#playlistItem",
            "etag": "etag",
            "id": "playlistItem2",
            "snippet": {
                "publishedAt": "2024-06-01T12:00:00Z",
                "channelId": "UCplaylist",
                "title": "Another Video",
                "description": "",
                "thumbnails": {},
                "channelTitle": "Playlist Channel",
                "playlistId": "PL456",
                "position": 1,
                "resourceId": { "kind": "youtube#video", "videoId": "vid2" }
            },
            "contentDetails": {
                "videoId": "vid2"
            }
        }
        """

        let item = try JSONDecoder().decode(PlaylistItem.self, from: json.data(using: .utf8)!)
        let video = item.toVideo()
        #expect(video.channelTitle == "Playlist Channel")
    }
}
