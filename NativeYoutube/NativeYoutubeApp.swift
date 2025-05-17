import APIClient
import Shared
import SwiftUI
import Dependencies

@main
struct NativeYoutubeApp: App {
    @StateObject private var coordinator = withDependencies {
        $0.apiClient = .liveValue
        $0.searchClient = .liveValue
        $0.playlistClient = .liveValue
        $0.appStateClient = .liveValue
    } operation: {
        AppCoordinator()
    }

    var body: some Scene {
        MenuBarExtra("Native Youtube", systemImage: "play.rectangle.fill") {
            ContentView()
                .environmentObject(coordinator)
                .frame(width: 360, height: 512)
        }
        .menuBarExtraStyle(WindowMenuBarExtraStyle())
    }
}