import Foundation

public struct YouTubePlaylistResponse: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let nextPageToken: String?
    public let prevPageToken: String?
    public let pageInfo: PageInfo
    public let items: [PlaylistItem]
}

public struct PlaylistItem: Codable, Equatable {
    public let kind: String
    public let etag: String
    public let id: String
    public let snippet: PlaylistSnippet
    public let contentDetails: ContentDetails
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