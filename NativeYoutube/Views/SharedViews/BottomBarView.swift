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
                CleanButton(
                    page: .playlists,
                    image: "music.note.list",
                    binded: $currentPage
                )
                CleanButton(
                    page: .search,
                    image: "magnifyingglass",
                    binded: $currentPage
                )
                if currentPage == .search {
                    HStack {
                        TextField("Search..", text: $searchViewModel.searchQuery)
                            .textFieldStyle(.plain)
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                            .onSubmit {
                                searchViewModel.startSearch(apiKey: appStateViewModel.apiKey)
                                appStateViewModel.addToLogs(for: .search, message: "Searching for \($searchViewModel.searchQuery)")
                            }
                    }
                    .transition(.offset(y: 120))
                    .animation(.linear, value: currentPage == .search)

                } else {
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
                .contextMenu {
                    Button {
                        NSApplication.shared.terminate(self)
                    } label: {
                        Label("Quit app", systemImage: "power")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 6)
            .labelStyle(.iconOnly)
            .background(.ultraThinMaterial)
            .cornerRadius(5)
            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
        }
    }
}

struct BottomBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarView(currentPage: .constant(.playlists))
            .environmentObject(AppStateViewModel())
    }
}
