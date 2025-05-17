import Foundation
import Dependencies
import DependenciesMacros
import Models

@DependencyClient
public struct APIClient {
    public var searchVideos: (SearchRequest) async throws -> [Video] = { _ in [] }
    public var fetchPlaylistVideos: (PlaylistRequest) async throws -> [Video] = { _ in [] }
}


public struct SearchRequest: Equatable {
    public init() {}
}

public struct PlaylistRequest: Equatable {
    public init() {}
}

// Dependency key for swift-dependencies
extension APIClient: TestDependencyKey {
    public static let previewValue = APIClient()
    public static let testValue = APIClient()
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}



