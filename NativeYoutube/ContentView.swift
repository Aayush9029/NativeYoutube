//
//  ContentView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject var searchViewModel = SearchViewModel()
    @StateObject var playlistViewModel = PlayListViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    @StateObject var youtubePlayerViewModel = YoutubePlayerViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch settingsViewModel.currentPage {
            case .playlists:
                PlayListView()
                    .environmentObject(playlistViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(youtubePlayerViewModel)
            case .search:
                SearchView()
                    .environmentObject(searchViewModel)
                    .environmentObject(settingsViewModel)
                    .environmentObject(youtubePlayerViewModel)
            }
            BottomBarView()
                .environmentObject(settingsViewModel)
        }
        .frame(width: 380.0)
        .onChange(of: playlistViewModel.currentStatus) { newValue in
            settingsViewModel.addToLogs(for: settingsViewModel.currentPage, message: newValue.rawValue)
        }
    }
}

enum Pages: String{
    case playlists = "Playlists"
    case search = "Search"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

