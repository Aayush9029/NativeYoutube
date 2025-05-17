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
    
    enum SearchStatus {
        case idle
        case searching
        case completed
        case error(String)
    }
    
    init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        // Listen for video player notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showVideoInApp(_:)),
            name: .showVideoInApp,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideVideoPlayer),
            name: .hideVideoPlayer,
            object: nil
        )
    }
    
    @objc private func showVideoInApp(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let url = userInfo["url"] as? URL,
              let title = userInfo["title"] as? String else { return }
        
        currentVideoURL = url
        currentVideoTitle = title
        showingVideoPlayer = true
    }
    
    @objc func hideVideoPlayer() {
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
    
    enum PlaylistStatus {
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
    
    // MARK: - App Actions
    
    func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
