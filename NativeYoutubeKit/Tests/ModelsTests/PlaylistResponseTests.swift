import CustomDump
import Foundation
import Models
import Testing

@Suite("Playlist Response Decoding")
struct PlaylistResponseTests {
    @Test("Decodes YouTube playlist API v3 response")
    func decodePlaylistResponse() throws {
        let json = """
        {
            "kind": "youtube#playlistItemListResponse",
            "etag": "playlist_etag",
            "nextPageToken": "QVFIUnhEaF8",
            "pageInfo": {
                "totalResults": 50,
                "resultsPerPage": 5
            },
            "items": [
                {
                    "kind": "youtube#playlistItem",
                    "etag": "item_etag",
                    "id": "UExWei1MWU5XMUhLY2lsX3p6eTUxWjZydXlOTFNKYkg3bS41NkI0NEY2RDEwNTU3Q0M2",
                    "snippet": {
                        "publishedAt": "2024-03-15T14:30:00Z",
                        "channelId": "UCplaylist",
                        "title": "Playlist Video Title",
                        "description": "Video in a playlist",
                        "thumbnails": {
                            "default": {
                                "url": "https://i.ytimg.com/vi/xyz789/default.jpg",
                                "width": 120,
                                "height": 90
                            },
                            "medium": {
                                "url": "https://i.ytimg.com/vi/xyz789/mqdefault.jpg",
                                "width": 320,
                                "height": 180
                            },
                            "high": {
                                "url": "https://i.ytimg.com/vi/xyz789/hqdefault.jpg",
                                "width": 480,
                                "height": 360
                            }
                        },
                        "channelTitle": "Playlist Owner Channel",
                        "playlistId": "PLVz-LYNW1HKcil",
                        "position": 0,
                        "resourceId": {
                            "kind": "youtube#video",
                            "videoId": "xyz789"
                        },
                        "videoOwnerChannelTitle": "Original Creator",
                        "videoOwnerChannelId": "UCcreator"
                    },
                    "contentDetails": {
                        "videoId": "xyz789",
                        "videoPublishedAt": "2024-01-01T00:00:00Z"
                    }
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(YouTubePlaylistResponse.self, from: data)

        #expect(response.kind == "youtube#playlistItemListResponse")
        #expect(response.nextPageToken == "QVFIUnhEaF8")
        #expect(response.pageInfo.totalResults == 50)
        #expect(response.items.count == 1)

        let item = response.items[0]
        #expect(item.snippet.title == "Playlist Video Title")
        #expect(item.snippet.videoOwnerChannelTitle == "Original Creator")
        #expect(item.contentDetails.videoId == "xyz789")
        #expect(item.snippet.resourceId.videoId == "xyz789")
        #expect(item.snippet.position == 0)
    }

    @Test("Decodes response with optional fields nil")
    func decodeWithNilOptionals() throws {
        let json = """
        {
            "kind": "youtube#playlistItemListResponse",
            "etag": "etag",
            "pageInfo": {
                "totalResults": 1,
                "resultsPerPage": 5
            },
            "items": [
                {
                    "kind": "youtube#playlistItem",
                    "etag": "etag",
                    "id": "itemId",
                    "snippet": {
                        "publishedAt": "2024-01-01T00:00:00Z",
                        "channelId": "UC1",
                        "title": "No Owner Title",
                        "description": "",
                        "thumbnails": {},
                        "channelTitle": "Playlist Channel",
                        "playlistId": "PL1",
                        "position": 0,
                        "resourceId": {
                            "kind": "youtube#video",
                            "videoId": "vid1"
                        }
                    },
                    "contentDetails": {
                        "videoId": "vid1"
                    }
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(YouTubePlaylistResponse.self, from: data)

        #expect(response.nextPageToken == nil)
        let item = response.items[0]
        #expect(item.snippet.videoOwnerChannelTitle == nil)
        #expect(item.contentDetails.startAt == nil)
        #expect(item.contentDetails.videoPublishedAt == nil)
    }
}
