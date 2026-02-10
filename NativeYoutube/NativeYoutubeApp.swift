import APIClient
import Clients
import Dependencies
import Sharing
import SwiftUI

@main
struct NativeYoutubeApp: App {
    @State private var coordinator = withDependencies {
        $0.apiClient = .liveValue
        $0.searchClient = .liveValue
        $0.playlistClient = .liveValue
        $0.appStateClient = .liveValue
    } operation: {
        AppCoordinator()
    }

    @State private var licenseManager = LicenseManager()
    @State private var showingNag = false

    var body: some Scene {
        MenuBarExtra("Native Youtube", systemImage: "play.rectangle.fill") {
            ContentView()
                .environment(coordinator)
                .environment(licenseManager)
                .frame(width: 360, height: 512)
                .sheet(isPresented: $showingNag) {
                    LicenseNagView()
                        .environment(licenseManager)
                }
                .task {
                    await licenseManager.validateExisting()
                }
                .onAppear {
                    if licenseManager.shouldShowNag {
                        showingNag = true
                    }
                }
        }
        .menuBarExtraStyle(WindowMenuBarExtraStyle())
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Native Youtube") {
                    NSApplication.shared.orderFrontStandardAboutPanel(nil)
                }
                Divider()
                Button("Check for Updates...") {
                    coordinator.checkForUpdates()
                }
            }
        }
    }
}
