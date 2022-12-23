//
//  ContentView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPage: Pages = .playlists

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            switch currentPage {
            case .playlists:
                PlayListView()
            case .search:
                SearchView()
            case .settings:
                PreferencesView()
            }
            BottomBarView(currentPage: $currentPage)
        }
        .frame(width: 380.0)
    }
}

enum Pages: String {
    case playlists = "Playlists"
    case search = "Search"
    case settings = "Settings"
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
