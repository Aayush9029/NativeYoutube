import Clients
import Dependencies
import Models
import Sharing
import SwiftUI
import Sparkle

@MainActor
@Observable
final class AppCoordinator {
    var currentPage: Pages = .playlists
    var searchQuery: String = ""
    var searchResults: [Video] = []
    var searchStatus: SearchStatus = .idle
    var playlistVideos: [Video] = []
    var selectedPlaylist: String = ""
    var showingVideoPlayer = false
    var currentVideoURL: URL?
    var currentVideoTitle: String = ""
    var playlistStatus: PlaylistStatus = .idle

    @ObservationIgnored @Dependency(\.searchClient) private var searchClient
    @ObservationIgnored @Dependency(\.appStateClient) private var appStateClient
    @ObservationIgnored @Dependency(\.floatingWindowClient) private var floatingWindowClient
    @ObservationIgnored @Dependency(\.playlistClient) private var playlistClient
    @ObservationIgnored private var settingsWindowController: NSWindowController?

    @ObservationIgnored @Shared(.apiKey) var apiKey
    @ObservationIgnored @Shared(.playlistID) var playlistID
    @ObservationIgnored @Shared(.logs) var logs
    @ObservationIgnored @Shared(.videoClickBehaviour) var videoClickBehaviour

    private let updaterController: SPUStandardUpdaterController

    enum SearchStatus: Equatable {
        case idle
        case searching
        case completed
        case error(String)
    }

    enum PlaylistStatus: Equatable {
        case idle
        case loading
        case completed
        case error(String)
    }

    init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)

        @Shared(.autoCheckUpdates) var autoCheckUpdates
        updaterController.updater.automaticallyChecksForUpdates = autoCheckUpdates
    }

    func showVideoInApp(_ url: URL, _ title: String) {
        currentVideoURL = url
        currentVideoTitle = title
        showingVideoPlayer = true
    }

    func hideVideoPlayer() {
        showingVideoPlayer = false
        currentVideoURL = nil
        currentVideoTitle = ""
    }

    // MARK: - Navigation

    func navigateTo(_ page: Pages) {
        currentPage = page
    }

    // MARK: - Search

    func search(_ query: String) async {
        guard !query.isEmpty else { return }

        searchQuery = query
        searchStatus = .searching

        do {
            searchResults = try await searchClient.searchVideos(query, apiKey)
            searchStatus = .completed
            $logs.withLock { $0.append("Search completed: \(searchResults.count) results") }
        } catch {
            searchStatus = .error(error.localizedDescription)
            $logs.withLock { $0.append("Search error: \(error.localizedDescription)") }
        }
    }

    // MARK: - Playlists

    func loadPlaylist() async {
        playlistStatus = .loading

        do {
            let videos = try await playlistClient.fetchVideos(apiKey, playlistID)
            playlistVideos = videos
            selectedPlaylist = playlistID
            playlistStatus = .completed
            $logs.withLock { $0.append("PlayList: Loaded \(videos.count) videos") }
        } catch {
            playlistStatus = .error(error.localizedDescription)
            $logs.withLock { $0.append("PlayList Error: \(error.localizedDescription)") }
        }
    }

    // MARK: - Video Actions

    func handleVideoTap(_ video: Video) async {
        switch videoClickBehaviour {
        case .nothing:
            return
        case .playVideo:
            await appStateClient.playVideo(video.url, video.title, false)
        case .openOnYoutube:
            appStateClient.openInYouTube(video.url)
        case .playInIINA:
            await appStateClient.playVideo(video.url, video.title, true)
        }
    }

    func playVideo(_ video: Video) async {
        await appStateClient.playVideo(video.url, video.title, false)
    }

    func playInIINA(_ video: Video) async {
        await appStateClient.playVideo(video.url, video.title, true)
    }

    func openInYouTube(_ video: Video) {
        appStateClient.openInYouTube(video.url)
    }

    func copyVideoLink(_ video: Video) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(video.url.absoluteString, forType: .string)
    }

    func shareVideo(_ url: URL) {
        let sharingPicker = NSSharingServicePicker(items: [url])
        if let window = NSApp.keyWindow {
            sharingPicker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
        }
    }

    // MARK: - App Actions

    func quit() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - Update Actions

    func checkForUpdates() {
        updaterController.checkForUpdates(nil)
    }

    func checkForUpdatesInBackground() {
        updaterController.updater.checkForUpdatesInBackground()
    }

    // MARK: - Settings Window

    func showSettings() {
        if let existingWindow = settingsWindowController?.window {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }

        let styleMask: NSWindow.StyleMask = [.titled, .closable, .fullSizeContentView]
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
            styleMask: styleMask,
            backing: .buffered,
            defer: false
        )
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = true
        window.level = .floating
        window.isMovableByWindowBackground = true

        let rootView = PreferencesView()

        window.contentView = NSHostingView(rootView: rootView)

        window.center()
        settingsWindowController = NSWindowController(window: window)
        settingsWindowController?.showWindow(nil)

        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.settingsWindowController = nil
        }
    }
}
