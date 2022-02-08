//
//  ContentView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    @StateObject var youtubePlayerViewModel = YoutubePlayerViewModel()

    @State private var currentPage: Pages = .playlists

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            switch currentPage {
            case .playlists:
                PlayListView()
                    .environmentObject(youtubePlayerViewModel)
            case .search:
                SearchView()
                    .environmentObject(youtubePlayerViewModel)
            }
            BottomBarView(currentPage: $currentPage)
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
            .environmentObject(AppStateViewModel())
    }
}

