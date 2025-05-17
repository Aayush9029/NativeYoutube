import Foundation
import Shared
import AppKit
import UI  // For PopupPlayerView

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
        showVideoInApp: { url, title in
            print("Preview: Showing video '\(title)' in app")
        },
        hideVideoPlayer: {
            print("Preview: Hiding video player")
        }
    )
    
    public static let testValue = AppStateClient()
}

extension DependencyValues {
    public var appStateClient: AppStateClient {
        get { self[AppStateClient.self] }
        set { self[AppStateClient.self] = newValue }
    }
}

extension AppStateClient {
    public static func live() -> Self {
        AppStateClient(
            playVideo: { url, title, useIINA in
                if useIINA {
                    let process = Process()
                    process.launchPath = "/usr/bin/open"
                    process.arguments = ["-a", "IINA", url.absoluteString]
                    process.launch()
                } else {
                    // Instead of opening in browser, show in-app player
                    NotificationCenter.default.post(
                        name: .showVideoInApp,
                        object: nil,
                        userInfo: ["url": url, "title": title]
                    )
                }
            },
            stopVideo: {
                let process = Process()
                process.launchPath = "/usr/bin/killall"
                process.arguments = ["IINA"]
                process.launch()
            },
            openInYouTube: { url in
                NSWorkspace.shared.open(url)
            },
            showVideoInApp: { url, title in
                // This would be implemented in the AppCoordinator to show the PopupPlayerView
                NotificationCenter.default.post(
                    name: .showVideoInApp,
                    object: nil,
                    userInfo: ["url": url, "title": title]
                )
            },
            hideVideoPlayer: {
                NotificationCenter.default.post(
                    name: .hideVideoPlayer,
                    object: nil
                )
            }
        )
    }
}

// Define notification names
extension Notification.Name {
    static let showVideoInApp = Notification.Name("showVideoInApp")
    static let hideVideoPlayer = Notification.Name("hideVideoPlayer")
}