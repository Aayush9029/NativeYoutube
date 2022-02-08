//
//  NativeYoutubeApp.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI

@main
struct NativeYoutubeApp: App {
    @StateObject private var appStateViewModel = AppStateViewModel()
    @StateObject private var statusBarController = StatusBarController()

    private func setupPopupMenu() {
        let contentView = ContentView()
            .environmentObject(appStateViewModel)

        let popover = NSPopover()

//         Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentViewController = MainHostingViewController(rootView: contentView)
        popover.contentSize = NSSize(width: 360, height: 400)

//         Create the Status Bar Item with the Popover
        statusBarController.start(with: popover)
    }

    var body: some Scene {
        WindowGroup {
            // We want to hide the window since we do not need it.
            ZStack {
                EmptyView()
            }
            .hidden()
            .onAppear {
                setupPopupMenu()
            }
        }

        Settings {
            PreferencesView()
                .environmentObject(appStateViewModel)
        }
    }
}
