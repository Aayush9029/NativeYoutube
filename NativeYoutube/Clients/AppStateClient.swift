import AppKit
import Dependencies
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

// Changed from TestDependencyKey to DependencyKey
extension AppStateClient: DependencyKey {
    public static let liveValue = AppStateClient(
        playVideo: { url, title, useIINA in
            if useIINA {
                // Open in IINA
                let iinaURL = URL(string: "iina://weblink?url=\(url.absoluteString)")!
                _ = await MainActor.run {
                    NSWorkspace.shared.open(iinaURL)
                }
            } else {
                // Show in-app player
                await MainActor.run {
                    NotificationCenter.default.post(
                        name: .showVideoInApp,
                        object: nil,
                        userInfo: ["url": url, "title": title]
                    )
                }
            }
        },
        stopVideo: {
            await MainActor.run {
                NotificationCenter.default.post(name: .hideVideoPlayer, object: nil)
            }
        },
        openInYouTube: { url in
            NSWorkspace.shared.open(url)
        },
        showVideoInApp: { url, title in
            NotificationCenter.default.post(
                name: .showVideoInApp,
                object: nil,
                userInfo: ["url": url, "title": title]
            )
        },
        hideVideoPlayer: {
            NotificationCenter.default.post(name: .hideVideoPlayer, object: nil)
        }
    )

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
