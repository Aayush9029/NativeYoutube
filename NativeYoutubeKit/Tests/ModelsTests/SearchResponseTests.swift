import CustomDump
import Foundation
import Models
import Testing

@Suite("Search Response Decoding")
struct SearchResponseTests {
    @Test("Decodes YouTube search API v3 response")
    func decodeSearchResponse() throws {
        let json = """
        {
            "kind": "youtube#searchListResponse",
            "etag": "test_etag",
            "nextPageToken": "CAUQAA",
            "regionCode": "US",
            "pageInfo": {
                "totalResults": 1000000,
                "resultsPerPage": 5
            },
            "items": [
                {
                    "kind": "youtube#searchResult",
                    "etag": "item_etag_1",
                    "id": {
                        "kind": "youtube#video",
                        "videoId": "dQw4w9WgXcQ"
                    },
                    "snippet": {
                        "publishedAt": "2024-01-01T00:00:00Z",
                        "channelId": "UCuAXFkgsw1L7xaCfnd5JJOw",
                        "title": "Test Video",
                        "description": "A test video description",
                        "thumbnails": {
                            "default": {
                                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/default.jpg",
                                "width": 120,
                                "height": 90
                            },
                            "medium": {
                                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg",
                                "width": 320,
                                "height": 180
                            },
                            "high": {
                                "url": "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg",
                                "width": 480,
                                "height": 360
                            }
                        },
                        "channelTitle": "Test Channel",
                        "liveBroadcastContent": "none"
                    }
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)

        #expect(response.kind == "youtube#searchListResponse")
        #expect(response.nextPageToken == "CAUQAA")
        #expect(response.regionCode == "US")
        #expect(response.pageInfo.totalResults == 1_000_000)
        #expect(response.pageInfo.resultsPerPage == 5)
        #expect(response.items.count == 1)

        let item = response.items[0]
        #expect(item.id.videoId == "dQw4w9WgXcQ")
        #expect(item.snippet.title == "Test Video")
        #expect(item.snippet.channelTitle == "Test Channel")
        #expect(item.snippet.thumbnails.medium?.url == "https://i.ytimg.com/vi/dQw4w9WgXcQ/mqdefault.jpg")
    }

    @Test("Decodes response with missing optional fields")
    func decodeMinimalResponse() throws {
        let json = """
        {
            "kind": "youtube#searchListResponse",
            "etag": "minimal",
            "pageInfo": {
                "totalResults": 0,
                "resultsPerPage": 5
            },
            "items": []
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)

        #expect(response.nextPageToken == nil)
        #expect(response.regionCode == nil)
        #expect(response.items.isEmpty)
    }

    @Test("Decodes thumbnails when width/height are missing")
    func decodeThumbnailWithoutDimensions() throws {
        let json = """
        {
            "kind": "youtube#searchListResponse",
            "etag": "test_missing_thumbnail_dimensions",
            "pageInfo": {
                "totalResults": 1,
                "resultsPerPage": 5
            },
            "items": [
                {
                    "kind": "youtube#searchResult",
                    "etag": "item_etag_2",
                    "id": {
                        "kind": "youtube#video",
                        "videoId": "abc123"
                    },
                    "snippet": {
                        "publishedAt": "2024-01-01T00:00:00Z",
                        "channelId": "UCtest",
                        "title": "Missing Thumbnail Dimensions",
                        "description": "test",
                        "thumbnails": {
                            "default": {
                                "url": "https://i.ytimg.com/vi/abc123/default.jpg"
                            }
                        },
                        "channelTitle": "Test Channel",
                        "liveBroadcastContent": "none"
                    }
                }
            ]
        }
        """

        let data = json.data(using: .utf8)!
        let response = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)

        let thumbnail = try #require(response.items.first?.snippet.thumbnails.default)
        #expect(thumbnail.url == "https://i.ytimg.com/vi/abc123/default.jpg")
        #expect(thumbnail.width == 0)
        #expect(thumbnail.height == 0)
    }
}
