//
//  BottomBarView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct BottomBarView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Group{
            HStack{
                CleanButton(title: "Playlists", image: "music.note.list", isCurrent: settingsViewModel.currentPage == .playlists)
                    .onTapGesture {
                        withAnimation {
                            settingsViewModel.currentPage = .playlists
                        }
                    }
                CleanButton(title: "Search", image: "magnifyingglass", isCurrent: settingsViewModel.currentPage == .search)
                    .onTapGesture {
                        withAnimation {
                            settingsViewModel.currentPage = .search
                        }
                    }
                Spacer()
                CleanButton(title: "Settings", image: settingsViewModel.showingSettings ? "rectangle" : "gear", isCurrent: false)
                    .onTapGesture {
                        if !settingsViewModel.showingSettings{
                            SettingsView()
                                .environmentObject(settingsViewModel)
                                .background(VisualEffectView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow))
                                .openNewWindow(with: "Native Youtube Settings")
                        }
                    }
                    .disabled(settingsViewModel.showingSettings)
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
        BottomBarView()
            .environmentObject(SettingsViewModel())
    }
}
