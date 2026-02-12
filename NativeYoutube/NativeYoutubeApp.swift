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
                    DispatchQueue.main.async {
                        isShowingNagOverlay = true
                    }
                }
                .disabled(isShowingNagOverlay)

            if isShowingNagOverlay {
                Color.black.opacity(0.28)
                    .ignoresSafeArea()
                    .onTapGesture { }
                    .transition(.opacity)

                LicenseNagView(
                    onLater: {
                        isShowingNagOverlay = false
                    },
                    onActivated: {
                        isShowingNagOverlay = false
                    }
                )
                    .environment(licenseManager)
                    .padding(12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.white.opacity(0.14), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.22), radius: 20, x: 0, y: 10)
                    .transition(.scale(scale: 0.97).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isShowingNagOverlay)
    }
}
