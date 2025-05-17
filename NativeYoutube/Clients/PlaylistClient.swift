import Foundation
import Shared
import Models
import APIClient

@DependencyClient
public struct PlaylistClient {
    public var fetchVideos: (_ apiKey: String, _ playlistId: String) async throws -> [Video] = { _, _ in [] }
}

extension PlaylistClient: TestDependencyKey {
    public static let previewValue = PlaylistClient()
    public static let testValue = PlaylistClient()
}

extension DependencyValues {
    public var playlistClient: PlaylistClient {
        get { self[PlaylistClient.self] }
        set { self[PlaylistClient.self] = newValue }
    }
}

extension PlaylistClient {
    public static func live() -> Self {
        @Dependency(\.apiClient) var apiClient
        
        return PlaylistClient(
            fetchVideos: { apiKey, playlistId in
                let request = PlaylistRequest(
                    playlistId: playlistId,
                    maxResults: 25,
                    apiKey: apiKey
                )
                return try await apiClient.fetchPlaylistVideos(request)
            }
        )
    }
}