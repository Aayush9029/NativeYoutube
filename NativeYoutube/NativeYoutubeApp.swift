import Shared
import SwiftUI

@main
struct NativeYoutubeApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        MenuBarExtra("Native Youtube", systemImage: "play.rectangle.fill") {
            ContentView()
                .environmentObject(coordinator)
                .frame(width: 360, height: 512)
        }
        .menuBarExtraStyle(WindowMenuBarExtraStyle())
    }
}
