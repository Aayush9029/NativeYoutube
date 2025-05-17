//
//  MockResponses.swift
//  NativeYoutubeTests
//

import Foundation

enum MockResponses {
    
    static let searchResponseJSON = """
    {
        "kind": "youtube#searchListResponse",
        "etag": "test-etag",
        "nextPageToken": "CAUQAA",
        "regionCode": "US",
        "pageInfo": {
            "totalResults": 1000000,
            "resultsPerPage": 5
        },
        "items": [
            {
                "kind": "youtube#searchResult",
                "etag": "item-etag",
                "id": {
                    "kind": "youtube#video",
                    "videoId": "dQw4w9WgXcQ"
                },
                "snippet": {
                    "publishedAt": "2009-10-25T06:57:33Z",
                    "channelId": "UCuAXFkgsw1L7xaCfnd5JJOw",
                    "title": "Rick Astley - Never Gonna Give You Up",
                    "description": "The official video for \\\"Never Gonna Give You Up\\\" by Rick Astley.",
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
                    "channelTitle": "Rick Astley",
                    "liveBroadcastContent": "none",
                    "publishTime": "2009-10-25T06:57:33Z"
                }
            }
        ]
    }
    """
    
    static let playlistResponseJSON = """
    {
        "kind": "youtube#playlistItemListResponse",
        "etag": "playlist-etag",
        "nextPageToken": "CBkQAA",
        "pageInfo": {
            "totalResults": 200,
            "resultsPerPage": 25
        },
        "items": [
            {
                "kind": "youtube#playlistItem",
                "etag": "playlist-item-etag",
                "id": "UExyVnhsd0RVMVFZTG9nODA0dVJIQnlSUzFZSWN3ODJEMS4xMDk1MzUzOTI5MTk",
                "snippet": {
                    "publishedAt": "2023-06-15T17:00:08Z",
                    "channelId": "UCHnyfMqiRRG1u-2MsSQLbXA",
                    "title": "Building a Better Computer",
                    "description": "Learn about the components and process of building a computer.",
                    "thumbnails": {
                        "default": {
                            "url": "https://i.ytimg.com/vi/BL4DCEp7blc/default.jpg",
                            "width": 120,
                            "height": 90
                        },
                        "medium": {
                            "url": "https://i.ytimg.com/vi/BL4DCEp7blc/mqdefault.jpg",
                            "width": 320,
                            "height": 180
                        },
                        "high": {
                            "url": "https://i.ytimg.com/vi/BL4DCEp7blc/hqdefault.jpg",
                            "width": 480,
                            "height": 360
                        }
                    },
                    "channelTitle": "Veritasium",
                    "playlistId": "PLrVzlwTE1QZLog804uRHByRS-YIcw82D1",
                    "position": 0,
                    "resourceId": {
                        "kind": "youtube#video",
                        "videoId": "BL4DCEp7blc"
                    },
                    "videoOwnerChannelTitle": "Veritasium",
                    "videoOwnerChannelId": "UCHnyfMqiRRG1u-2MsSQLbXA"
                },
                "contentDetails": {
                    "videoId": "BL4DCEp7blc",
                    "startAt": "PT0S",
                    "endAt": "PT15M51S",
                    "note": "",
                    "videoPublishedAt": "2023-06-15T17:00:08Z"
                }
            }
        ]
    }
    """
    
    static let videoResponseJSON = """
    {
        "kind": "youtube#videoListResponse",
        "etag": "video-etag",
        "pageInfo": {
            "totalResults": 1,
            "resultsPerPage": 1
        },
        "items": [
            {
                "kind": "youtube#video",
                "etag": "video-item-etag",
                "id": "dQw4w9WgXcQ",
                "snippet": {
                    "publishedAt": "2009-10-25T06:57:33Z",
                    "channelId": "UCuAXFkgsw1L7xaCfnd5JJOw",
                    "title": "Rick Astley - Never Gonna Give You Up (Official Video)",
                    "description": "The official video for \\\"Never Gonna Give You Up\\\" by Rick Astley.",
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
                    "channelTitle": "Rick Astley",
                    "tags": [
                        "rick astley",
                        "Never Gonna Give You Up",
                        "rickroll",
                        "rick roll"
                    ],
                    "categoryId": "10",
                    "liveBroadcastContent": "none",
                    "localized": {
                        "title": "Rick Astley - Never Gonna Give You Up (Official Video)",
                        "description": "The official video for \\\"Never Gonna Give You Up\\\" by Rick Astley."
                    },
                    "defaultAudioLanguage": "en"
                },
                "contentDetails": {
                    "duration": "PT3M32S",
                    "dimension": "2d",
                    "definition": "hd",
                    "caption": "false",
                    "licensedContent": true,
                    "contentRating": {},
                    "projection": "rectangular"
                },
                "statistics": {
                    "viewCount": "1234567890",
                    "likeCount": "12345678",
                    "dislikeCount": "123456",
                    "favoriteCount": "0",
                    "commentCount": "1234567"
                }
            }
        ]
    }
    """
    
    // Helper methods to get decoded responses
    static var searchResponse: Data {
        searchResponseJSON.data(using: .utf8)!
    }
    
    static var playlistResponse: Data {
        playlistResponseJSON.data(using: .utf8)!
    }
    
    static var videoResponse: Data {
        videoResponseJSON.data(using: .utf8)!
    }
}