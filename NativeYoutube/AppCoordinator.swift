import Clients
import Dependencies
import IdentifiedCollections
import Models
import Sharing
import SwiftUI
import Sparkle

@MainActor
@Observable
final class AppCoordinator {
    var currentPage: Pages = .playlists
    var searchQuery: String = ""
    var searchResults: IdentifiedArrayOf<Video> = []
    var searchStatus: SearchStatus = .idle
    var playlistVideos: IdentifiedArrayOf<Video> = []
    var selectedPlaylist: String = ""
    var showingVideoPlayer = false
    var currentVideoURL: URL?
    var currentVideoTitle: String = ""
    var playlistStatus: PlaylistStatus = .idle

    @ObservationIgnored @Dependency(\.searchClient) private var searchClient
    @ObservationIgnored @Dependency(\.appStateClient) private var appStateClient
    @ObservationIgnored @Dependency(\.playlistClient) private var playlistClient

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

    // MARK: - Navigation

    func pageButtonTapped(_ page: Pages) {
        currentPage = page
    }

    // MARK: - Search

    func searchSubmitted(_ query: String) async {
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

    func playlistViewTask() async {
        await loadPlaylistVideos()
    }

    func playlistIDDidChange() async {
        await loadPlaylistVideos()
    }

    private func loadPlaylistVideos() async {
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

    func videoDoubleTapped(_ video: Video) async {
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

    func playVideoButtonTapped(_ video: Video) async {
        await appStateClient.playVideo(video.url, video.title, false)
    }

    func playInIINAButtonTapped(_ video: Video) async {
        await appStateClient.playVideo(video.url, video.title, true)
    }

    func openInYouTubeButtonTapped(_ video: Video) {
        appStateClient.openInYouTube(video.url)
    }

    func copyLinkButtonTapped(_ video: Video) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(video.url.absoluteString, forType: .string)
    }

    func shareButtonTapped(_ url: URL) {
        let sharingPicker = NSSharingServicePicker(items: [url])
        if let window = NSApp.keyWindow {
            sharingPicker.show(relativeTo: .zero, of: window.contentView!, preferredEdge: .minY)
        }
    }

    // MARK: - App Actions

    func quitButtonTapped() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - Update Actions

    func checkForUpdatesButtonTapped() {
        updaterController.checkForUpdates(nil)
    }
}
