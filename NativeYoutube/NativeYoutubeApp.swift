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
    @StateObject private var searchViewModel = SearchViewModel()
    var body: some Scene {
        MenuBarExtra("Native Youtube", systemImage: "play.rectangle.fill") {
            ContentView()
                .frame(width: 360, height: 512)
                .environmentObject(appStateViewModel)
                .environmentObject(searchViewModel)
        }
        .menuBarExtraStyle(WindowMenuBarExtraStyle())
    }
}
