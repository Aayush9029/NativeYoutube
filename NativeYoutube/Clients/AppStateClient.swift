import Foundation
import Shared
import AppKit

@DependencyClient  
public struct AppStateClient {
    public var playVideo: (_ url: URL, _ title: String, _ useIINA: Bool) async -> Void = { _, _, _ in }
    public var stopVideo: () async -> Void = {}
    public var openInYouTube: (_ url: URL) -> Void = { _ in }
}

extension AppStateClient: TestDependencyKey {
    public static let previewValue = AppStateClient()
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
                    NSWorkspace.shared.open(url)
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
            }
        )
    }
}