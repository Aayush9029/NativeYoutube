import AppKit
import Dependencies
import Foundation
import Shared
import SwiftUI

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
                    // Use mpv to play YouTube videos
                    await MainActor.run {
                        // Common locations for IINA's mpv binary
                        let possibleMpvPaths = [
                            "/Applications/IINA.app/Contents/Frameworks/MPVPlayer.framework/Versions/A/Resources/mpv",
                            "/Applications/IINA.app/Contents/MacOS/mpv",
                            "/usr/local/bin/mpv" // Fallback to system mpv if available
                        ]

                        // Find the first available mpv binary
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
                                print("Failed to launch mpv: \(error)")
                                // Fallback to IINA URL scheme
                                let iinaURL = URL(string: "iina://weblink?url=\(url.absoluteString)")!
                                NSWorkspace.shared.open(iinaURL)
                            }
                        } else {
                            // Fallback to IINA URL scheme if mpv binary not found
                            let iinaURL = URL(string: "iina://weblink?url=\(url.absoluteString)")!
                            NSWorkspace.shared.open(iinaURL)
                        }
                    }
                } else {
                    // Show in YouTube player window
                    await MainActor.run {
                        // Create player view content
                        let playerView = YouTubePlayerView(
                            videoURL: url,
                            title: title
                        )
                        
                        let hostingView = NSHostingView(rootView: playerView)
                        
                        // Create floating panel if it doesn't exist
                        if !windowClient.isVisible() {
                            windowClient.createFloatingPanel(hostingView)
                        } else {
                            windowClient.updateContent(hostingView)
                        }
                        
                        // Show the panel
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
                // This method is used to show video in the main app window overlay
                // The coordinator handles this directly now via playVideo
            },
            hideVideoPlayer: {
                Task { @MainActor in
                    windowClient.hidePanel()
                }
            }
        )
    }

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
