import Foundation

// YouTube API Response Models with Codable conformance

public struct YouTubeSearchResponse: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let regionCode: String?
    public let pageInfo: PageInfo
    public let items: [SearchItem]
}

public struct YouTubePlaylistResponse: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let pageInfo: PageInfo
    public let items: [PlaylistItem]
}

public struct PageInfo: Codable, Equatable {
    public let totalResults: Int
    public let resultsPerPage: Int
}

public struct SearchItem: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let id: SearchId
    public let snippet: SearchSnippet
}

public struct PlaylistItem: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let id: String
    public let snippet: PlaylistSnippet
    public let contentDetails: ContentDetails
}

public struct SearchId: Codable, Equatable {
    public let kind: String
    public let videoId: String?
    public let channelId: String?
    public let playlistId: String?
}

public struct SearchSnippet: Codable, Equatable {
    public let publishedAt: String
    public let channelId: String
    public let title: String
    public let description: String
    public let thumbnails: Thumbnails
    public let channelTitle: String
    public let liveBroadcastContent: String
}

public struct PlaylistSnippet: Codable, Equatable {
    public let publishedAt: String
    public let channelId: String
    public let title: String
    public let description: String
    public let thumbnails: Thumbnails
    public let channelTitle: String
    public let playlistId: String
    public let position: Int
    public let resourceId: ResourceId
    public let videoOwnerChannelTitle: String?
    public let videoOwnerChannelId: String?
}

public struct ContentDetails: Codable, Equatable {
    public let videoId: String
    public let startAt: String?
    public let endAt: String?
    public let note: String?
    public let videoPublishedAt: String?
}

public struct ResourceId: Codable, Equatable {
    public let kind: String
    public let videoId: String
}

public struct Thumbnails: Codable, Equatable {
    public let `default`: Thumbnail?
    public let medium: Thumbnail?
    public let high: Thumbnail?
    public let standard: Thumbnail?
    public let maxres: Thumbnail?
}

public struct Thumbnail: Codable, Equatable {
    public let url: String
    public let width: Int
    public let height: Int
}

// Video transformation helpers
public extension SearchItem {
    func toVideo() -> Video? {
        guard let videoId = id.videoId else { return nil }
        let url = URL(string: "\(Constants.templateYoutubeURL)\(videoId)")!
        let thumbnail = URL(string: snippet.thumbnails.medium?.url ?? "https://via.placeholder.com/140x100")!
        let publishedAt = DateConverter.timestampToDate(timestamp: snippet.publishedAt)
        
        return Video(
            id: videoId,
            title: snippet.title,
            thumbnail: thumbnail,
            publishedAt: publishedAt,
            url: url,
            channelTitle: snippet.channelTitle
        )
    }
}

public extension PlaylistItem {
    func toVideo() -> Video {
        let videoId = contentDetails.videoId
        let url = URL(string: "\(Constants.templateYoutubeURL)\(videoId)")!
        let thumbnail = URL(string: snippet.thumbnails.medium?.url ?? "https://via.placeholder.com/140x100")!
        let publishedAt = DateConverter.timestampToDate(timestamp: snippet.publishedAt)
        let channelTitle = snippet.videoOwnerChannelTitle ?? snippet.channelTitle
        
        return Video(
            id: videoId,
            title: snippet.title,
            thumbnail: thumbnail,
            publishedAt: publishedAt,
            url: url,
            channelTitle: channelTitle
        )
    }
}