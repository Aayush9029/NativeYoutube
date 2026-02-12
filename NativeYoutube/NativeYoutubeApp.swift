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

    var body: some Scene {
        MenuBarExtra("Native Youtube", systemImage: "play.rectangle.fill") {
            MenuBarRootView(coordinator: coordinator, licenseManager: licenseManager)
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

private struct MenuBarRootView: View {
    @State private var isShowingNagOverlay = false

    let coordinator: AppCoordinator
    let licenseManager: LicenseManager

    private var isShowingOverlay: Bool {
        isShowingNagOverlay || licenseManager.overlay != nil
    }

    var body: some View {
        ZStack {
            ContentView()
                .environment(coordinator)
                .environment(licenseManager)
                .frame(width: 360, height: 512)
                .task {
                    await licenseManager.validateExisting()
                }
                .onAppear {
                    licenseManager.recordMenuOpen()

                    guard licenseManager.shouldShowNag else { return }
                    guard !isShowingNagOverlay else { return }
                    guard licenseManager.overlay == nil else { return }
                    DispatchQueue.main.async {
                        isShowingNagOverlay = true
                    }
                }
                .disabled(isShowingOverlay)

            if isShowingNagOverlay {
                LicenseNagView(
                    onLater: {
                        isShowingNagOverlay = false
                    },
                    onActivated: {
                        isShowingNagOverlay = false
                    }
                )
                    .environment(licenseManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }

            if licenseManager.overlay == .activation {
                LicenseActivationView(
                    onCancel: {
                        licenseManager.dismissOverlay()
                    },
                    onActivated: {
                        licenseManager.dismissOverlay()
                    }
                )
                .environment(licenseManager)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isShowingNagOverlay)
        .animation(.easeInOut(duration: 0.2), value: licenseManager.overlay)
    }
}
