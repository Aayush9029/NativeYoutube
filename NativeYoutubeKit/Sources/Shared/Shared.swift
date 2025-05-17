@_exported import Dependencies
@_exported import DependenciesMacros
import Foundation
@_exported import IdentifiedCollections
@_exported import Sharing
@_exported import YouTubeKit

// Shared module for common utilities and types

public enum SharedConstants {
    public static let appName = "NativeYoutube"
    public static let bundleIdentifier = "com.aayush.nativeyoutube"
}

// Extension for async operations
public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
