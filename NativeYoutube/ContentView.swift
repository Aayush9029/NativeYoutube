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
    @State var currentPage: Pages = .playlists
    @State var settingsViewModel = SettingsViewModel()
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                VStack(alignment: .leading, spacing: 0) {
                    switch currentPage {
                    case .playlists:
                        PlayListView()
                            .environmentObject(playlistViewModel)
                            .environmentObject(settingsViewModel)
                    case .search:
                        SearchView()
                            .environmentObject(searchViewModel)
                            .environmentObject(settingsViewModel)
                    }
                }
                Divider()
                Spacer(minLength: 25)
            }
            HStack{
                CleanButton(title: "Playlists", image: "music.note.list", isCurrent: currentPage == .playlists)
                    .onTapGesture {
                        currentPage = .playlists
                    }
                CleanButton(title: "Search", image: "magnifyingglass", isCurrent: currentPage == .search)
                    .onTapGesture {
                        currentPage = .search
                    }
                Spacer()
                CleanButton(title: "Settings", image: "gear", isCurrent: false)
                    .onTapGesture {
                        if !settingsViewModel.showingSettings{
                        SettingsView()
                            .environmentObject(settingsViewModel)
                            .background(VisualEffectView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
                            .openNewWindow(with: "Native Twitch Settings")
                        }
                        settingsViewModel.showingSettings.toggle()
                    }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .labelStyle(.iconOnly)
            .background(.ultraThinMaterial)
            .cornerRadius(5)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
        }
        .frame(width: 380.0)
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
