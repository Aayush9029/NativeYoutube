import Foundation
import Models
import Sharing

// Default values
private enum DefaultValues {
    static let apiKey = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    static let playlistID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
}

// Persistent storage using FileStorage
extension SharedReaderKey where Self == AppStorageKey<String>.Default {
    static var apiKey: Self {
        Self[.appStorage("youtube.apiKey"), default: DefaultValues.apiKey]
    }
    
    static var playlistID: Self {
        Self[.appStorage("youtube.playlistID"), default: DefaultValues.playlistID]
    }
}

extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
    static var useIINA: Self {
        Self[.appStorage("youtube.useIINA"), default: false]
    }
}

extension SharedReaderKey where Self == AppStorageKey<VideoClickBehaviour>.Default {
    static var videoClickBehaviour: Self {
        Self[.appStorage("youtube.videoClickBehaviour"), default: .playVideo]
    }
}

// In-memory keys for runtime state
extension SharedReaderKey where Self == InMemoryKey<[String]>.Default {
    static var logs: Self {
        Self[.inMemory("logs"), default: []]
    }
}

extension SharedReaderKey where Self == InMemoryKey<Bool>.Default {
    static var isPlaying: Self {
        Self[.inMemory("isPlaying"), default: false]
    }
}

extension SharedReaderKey where Self == InMemoryKey<String>.Default {
    static var currentlyPlaying: Self {
        Self[.inMemory("currentlyPlaying"), default: ""]
    }
}