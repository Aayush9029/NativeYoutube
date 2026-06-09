import AppKit
import Dependencies
import DependenciesMacros
import Foundation
import OSLog
import Shared
import SwiftUI

private let appStateLogger = Logger(
    subsystem: "com.pokharel.aayush.nativeyoutube",
    category: "AppStateClient"
)

@DependencyClient
public struct AppStateClient {
    public var playVideo: (_ url: URL, _ title: String, _ useIINA: Bool) async -> Void = { _, _, _ in }
    public var stopVideo: () async -> Void = {}
    public var openInYouTube: (_ url: URL) -> Void = { _ in }
    public var showVideoInApp: @Sendable (_ url: URL, _ title: String) -> Void = { _, _ in }
    public var hideVideoPlayer: @Sendable () -> Void = {}
}

extension AppStateClient: DependencyKey {
    public static var liveValue: AppStateClient {
        @Dependency(\.floatingWindowClient) var windowClient

        return AppStateClient(
            playVideo: { url, title, useIINA in
                if useIINA {
                    await MainActor.run {
                        let possibleMpvPaths = [
                            "/Applications/IINA.app/Contents/Frameworks/MPVPlayer.framework/Versions/A/Resources/mpv",
                            "/Applications/IINA.app/Contents/MacOS/mpv",
                            "/usr/local/bin/mpv"
                        ]

                        let mpvPath = possibleMpvPaths.first { path in
                            FileManager.default.fileExists(atPath: path)
                        }

                        if let mpvPath = mpvPath {
                            let task = Process()
                            task.executableURL = URL(fileURLWithPath: mpvPath)
                            task.arguments = ["--force-window=yes", "--title=\(title)", url.absoluteString]

                            do {
                                try task.run()
                            } catch {
                                appStateLogger.error("Failed to launch mpv: \(error.localizedDescription, privacy: .public)")
                                let iinaURL = URL(string: "iina://weblink?url=\(url.absoluteString)")!
                                NSWorkspace.shared.open(iinaURL)
                            }
                        } else {
                            let iinaURL = URL(string: "iina://weblink?url=\(url.absoluteString)")!
                            NSWorkspace.shared.open(iinaURL)
                        }
                    }
                } else {
                    await MainActor.run {
                        let playerView = YouTubePlayerView(
                            videoURL: url,
                            title: title
                        )
                        
                        let hostingView = NSHostingView(rootView: playerView)
                        
                        if !windowClient.isVisible() {
                            windowClient.createFloatingPanel(hostingView)
                        } else {
                            windowClient.updateContent(hostingView)
                        }
                        
                        windowClient.showPanel()
                    }
                }
            },
            stopVideo: {
                await MainActor.run {
                    windowClient.hidePanel()
                }
            },
            openInYouTube: { url in
                NSWorkspace.shared.open(url)
            },
            showVideoInApp: { _, _ in
            },
            hideVideoPlayer: {
                Task { @MainActor in
                    windowClient.hidePanel()
                }
            }
        )
    }

    public static let previewValue = AppStateClient()

    public static let testValue = AppStateClient()
}

public extension DependencyValues {
    var appStateClient: AppStateClient {
        get { self[AppStateClient.self] }
        set { self[AppStateClient.self] = newValue }
    }
}
