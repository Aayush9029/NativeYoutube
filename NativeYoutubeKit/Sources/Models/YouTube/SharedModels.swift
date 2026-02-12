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

    public init(url: String, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }

    private enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        width = container.decodeLossyInt(forKey: .width) ?? 0
        height = container.decodeLossyInt(forKey: .height) ?? 0
    }
}

private extension KeyedDecodingContainer {
    func decodeLossyInt(forKey key: K) -> Int? {
        if let intValue = try? decodeIfPresent(Int.self, forKey: key) {
            return intValue
        }

        if let doubleValue = try? decodeIfPresent(Double.self, forKey: key) {
            return Int(doubleValue)
        }

        if let stringValue = try? decodeIfPresent(String.self, forKey: key) {
            return Int(stringValue)
        }

        return nil
    }
}
