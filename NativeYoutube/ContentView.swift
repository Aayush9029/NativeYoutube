//
//  ContentView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import Models
import UI
import Shared
import Dependencies

struct ContentView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @Shared(.isPlaying) private var isPlaying
    @Shared(.currentlyPlaying) private var currentlyPlaying
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            switch coordinator.currentPage {
            case .playlists:
                PlayListView()
            case .search:
                SearchVideosView()
            case .settings:
                PreferencesView()
            }
            BottomBarView(
                currentPage: $coordinator.currentPage,
                searchQuery: $coordinator.searchQuery,
                isPlaying: isPlaying,
                currentlyPlaying: currentlyPlaying,
                onSearch: {
                    coordinator.navigateTo(.search)
                    Task {
                        await coordinator.search(coordinator.searchQuery)
                    }
                },
                onQuit: coordinator.quit
            )
        }
        .frame(width: 360.0)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppCoordinator())
}