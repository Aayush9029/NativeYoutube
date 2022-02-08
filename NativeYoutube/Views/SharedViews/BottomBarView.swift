//
//  BottomBarView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    @Binding var currentPage: Pages

    var body: some View {
        Group {
            HStack {
                CleanButton(title: "Playlists", image: "music.note.list", isCurrent: currentPage == .playlists)
                    .onTapGesture {
                        withAnimation {
                            currentPage = .playlists
                        }
                    }
                CleanButton(title: "Search", image: "magnifyingglass", isCurrent: currentPage == .search)
                    .onTapGesture {
                        withAnimation {
                            currentPage = .search
                        }
                    }
                if appStateViewModel.isPlaying {
                    ScrollView(.horizontal, showsIndicators: false) {
                    Text("\(appStateViewModel.currentlyPlaying)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    }
                    .lineLimit(1)
                }
                Spacer()
                CleanButton(title: "Settings", image: appStateViewModel.showingSettings ? "rectangle" : "gear", isCurrent: false)
                    .contextMenu(menuItems: {
                        Button("Close App") {
                            NSApplication.shared.terminate(self)
                        }
                    })
                    .onTapGesture {
                        if !appStateViewModel.showingSettings {
                            NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                        }
                    }
                    .disabled(appStateViewModel.showingSettings)
            }
            .padding(.horizontal)
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
