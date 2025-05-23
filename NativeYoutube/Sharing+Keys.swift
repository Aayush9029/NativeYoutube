import Foundation
import Models
import Sharing

// Default values
private enum DefaultValues {
    // Note this might expire at any time so generate yours
    static let apiKey = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    static let playlistID = "PLVz-LYNW1HKcil_zzy51Z6ruyNLSJbH7m"
}

// Persistent storage using FileStorage
extension SharedReaderKey where Self == AppStorageKey<String>.Default {
    static var apiKey: Self {
        Self[.appStorage("apiKey"), default: DefaultValues.apiKey]
    }

    static var playlistID: Self {
        Self[.appStorage("playlistID"), default: DefaultValues.playlistID]
    }
}

extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
    static var useIINA: Self {
        Self[.appStorage("useIINA"), default: false]
    }

    static var autoCheckUpdates: Self {
        Self[.appStorage("autoCheckUpdates"), default: true]
    }
}

extension SharedReaderKey where Self == AppStorageKey<VideoClickBehaviour>.Default {
    static var videoClickBehaviour: Self {
        Self[.appStorage("videoClickBehaviour"), default: .playVideo]
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
