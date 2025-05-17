import Foundation

public struct YouTubeSearchResponse: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let regionCode: String?
    public let pageInfo: PageInfo
    public let items: [SearchItem]
}

public struct SearchItem: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let id: SearchId
    public let snippet: SearchSnippet
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