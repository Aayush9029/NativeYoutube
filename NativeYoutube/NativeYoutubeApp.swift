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
    @StateObject private var youtubePlayerViewModel = YoutubePlayerViewModel()
    var body: some Scene {
        MenuBarExtra("Native Youtube", systemImage: "play.circle") {
            ContentView()
                .frame(width: 360, height: 400)
                .environmentObject(appStateViewModel)
                .environmentObject(youtubePlayerViewModel)
        }
        .menuBarExtraStyle(WindowMenuBarExtraStyle())

        Settings {
            PreferencesView()
                .environmentObject(appStateViewModel)
        }
    }
}
