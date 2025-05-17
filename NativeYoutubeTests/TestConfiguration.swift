import Foundation
import Dependencies
@testable import NativeYoutube
import APIClient
import Clients
import Models
import Shared

// Test configuration for shared test dependencies
struct TestConfiguration {
    static func withTestDependencies<T>(
        operation: @escaping () async throws -> T
    ) async throws -> T {
        try await withDependencies {
            $0.apiClient = .test
            $0.searchClient = .test
            $0.playlistClient = .test
            $0.appStateClient = .test
        } operation: {
            try await operation()
        }
    }
}

// Test extensions for AppStateClient
extension AppStateClient {
    static let test = AppStateClient(
        playVideo: { _, _, _ in
            // Mock implementation
        },
        stopVideo: {
            // Mock implementation
        },
        openInYouTube: { _ in
            // Mock implementation
        },
        showVideoInApp: { _, _ in
            // Mock implementation
        },
        hideVideoPlayer: {
            // Mock implementation
        }
    )
}