//
//  BottomBarView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var searchViewModel: SearchViewModel
    @Binding var currentPage: Pages

    var body: some View {
        Group {
            HStack {
                Group {
                    CleanButton(
                        page: .playlists,
                        image: "music.note.list",
                        binded: $currentPage
                    )
                    .keyboardShortcut("m", modifiers: .command)
                    CleanButton(
                        page: .search,
                        image: "magnifyingglass",
                        binded: $currentPage
                    ).keyboardShortcut("s", modifiers: .command)
                }

                if currentPage == .search {
                    Group {
                        HStack {
                            TextField("Search..", text: $searchViewModel.searchQuery)
                                .textFieldStyle(.plain)
                                .thinRoundedBG(padding: 6, radius: 6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                                )
                                .onSubmit {
                                    searchViewModel.startSearch(apiKey: appStateViewModel.apiKey)
                                    appStateViewModel.addToLogs(for: .search, message: "Searching for \($searchViewModel.searchQuery)")
                                }
                        }
                        .transition(.offset(y: 120))
                        .animation(.linear, value: currentPage == .search)
                    }
                } else {
                    Group {
                        if appStateViewModel.isPlaying {
                            ScrollView(.horizontal, showsIndicators: false) {
                                Text("\(appStateViewModel.currentlyPlaying)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .lineLimit(1)
                        }

                        Spacer()
                    }
                    CleanButton(
                        page: .settings,
                        image: "gear",
                        binded: $currentPage
                    )
                    .keyboardShortcut(",", modifiers: .command)
                    .contextMenu {
                        Button {
                            NSApplication.shared.terminate(self)
                        } label: {
                            Label("Quit app", systemImage: "power")
                                .labelStyle(.titleAndIcon)
                        }
                    }
                }
            }
            .labelStyle(.iconOnly)
            .thinRoundedBG(padding: 6, radius: 6)
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(currentPage: .constant(.playlists))
            .environmentObject(AppStateViewModel())
    }
}
