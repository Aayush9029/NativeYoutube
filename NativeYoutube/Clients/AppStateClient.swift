import AppKit
import Foundation
import Shared

@DependencyClient
public struct AppStateClient {
    public var playVideo: (_ url: URL, _ title: String, _ useIINA: Bool) async -> Void = { _, _, _ in }
    public var stopVideo: () async -> Void = {}
    public var openInYouTube: (_ url: URL) -> Void = { _ in }
    public var showVideoInApp: @Sendable (_ url: URL, _ title: String) -> Void = { _, _ in }
    public var hideVideoPlayer: @Sendable () -> Void = {}
}

extension AppStateClient: TestDependencyKey {
    public static let previewValue = AppStateClient(
        playVideo: { url, title, useIINA in
            // Mock implementation for previews
            print("Preview: Playing video '\(title)' at \(url) \(useIINA ? "with IINA" : "in app")")
        },
        stopVideo: {
            print("Preview: Stopping video")
        },
        openInYouTube: { url in
            print("Preview: Opening \(url) in YouTube")
        },
        showVideoInApp: { _, title in
            print("Preview: Showing video '\(title)' in app")
        },
        hideVideoPlayer: {
            print("Preview: Hiding video player")
        }
    )

    public static let testValue = AppStateClient()
}

public extension DependencyValues {
    var appStateClient: AppStateClient {
        get { self[AppStateClient.self] }
        set { self[AppStateClient.self] = newValue }
    }
}

// Define notification names
extension Notification.Name {
    static let showVideoInApp = Notification.Name("showVideoInApp")
    static let hideVideoPlayer = Notification.Name("hideVideoPlayer")
}
