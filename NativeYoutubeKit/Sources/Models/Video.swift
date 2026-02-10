import Foundation

// Video model with proper Codable conformance
public struct Video: Codable, Equatable, Hashable, Identifiable {
    public let id: String
    public let title: String
    public let thumbnail: URL
    public let publishedAt: String
    public let url: URL
    public let channelTitle: String
    
    public init(
        id: String,
        title: String,
        thumbnail: URL,
        publishedAt: String,
        url: URL,
        channelTitle: String
    ) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.publishedAt = publishedAt
        self.url = url
        self.channelTitle = channelTitle
    }
}