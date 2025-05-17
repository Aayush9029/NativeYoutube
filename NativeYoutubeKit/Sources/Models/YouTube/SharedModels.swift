import Foundation

public struct PageInfo: Codable, Equatable {
    public let totalResults: Int
    public let resultsPerPage: Int
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