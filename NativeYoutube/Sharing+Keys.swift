import Foundation
import Models
import Sharing

private enum DefaultValues {
    static let apiKey = ""
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

    static var licenseKey: Self {
        Self[.appStorage("licenseKey"), default: ""]
    }

    static var deviceID: Self {
        Self[.appStorage("deviceID"), default: ""]
    }
}

extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
    static var useIINA: Self {
        Self[.appStorage("useIINA"), default: false]
    }

    static var autoCheckUpdates: Self {
        Self[.appStorage("autoCheckUpdates"), default: true]
    }

    static var isLicenseActivated: Self {
        Self[.appStorage("isLicenseActivated"), default: false]
    }
}

extension SharedReaderKey where Self == AppStorageKey<Int>.Default {
    static var menuOpenCount: Self {
        Self[.appStorage("menuOpenCount"), default: 0]
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
