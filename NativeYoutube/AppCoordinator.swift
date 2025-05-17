import Clients
import Dependencies
import Models
import Shared
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var currentPage: Pages = .playlists
    @Published var searchQuery: String = ""
    @Published var searchResults: [Video] = []
    @Published var searchStatus: SearchStatus = .idle
    @Published var playlistVideos: [Video] = []
    @Published var selectedPlaylist: String = ""
    @Published var showingVideoPlayer = false
    @Published var currentVideoURL: URL?
    @Published var currentVideoTitle: String = ""
    
    @Dependency(\.searchClient) private var searchClient
    @Dependency(\.appStateClient) private var appStateClient
    @Dependency(\.floatingWindowClient) private var floatingWindowClient
    private var settingsWindowController: NSWindowController?
    
    enum SearchStatus: Equatable {
        case idle
        case searching
        case completed
        case error(String)
    }
    
    init() {
    }
    
    
    func showVideoInApp(_ url: URL, _ title: String) {
        // Only show overlay if not popup mode
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
        
        @Shared(.apiKey) var apiKey
        @Shared(.logs) var logs
        
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
    
    @Dependency(\.playlistClient) private var playlistClient
    @Published var playlistStatus: PlaylistStatus = .idle
    
    enum PlaylistStatus: Equatable {
        case idle
        case loading
        case completed
        case error(String)
    }
    
    func loadPlaylist() async {
        @Shared(.apiKey) var apiKey
        @Shared(.playlistID) var playlistID
        @Shared(.logs) var logs
        
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
        @Shared(.videoClickBehaviour) var videoClickBehaviour
        
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
    
    // MARK: - Settings Window
    
    func showSettings() {
        // If the settings window already exists, just bring it to the front.
        if let existingWindow = settingsWindowController?.window {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }

        // Use a standard titled/closable window so it can become the key window
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

        // Position the window and show it.
        window.center()
        settingsWindowController = NSWindowController(window: window)
        settingsWindowController?.showWindow(nil)

        // Clean up when the window closes.
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            self?.settingsWindowController = nil
        }
    }
    
}
