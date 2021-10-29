//
//  SearchedVideosView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SearchedVideosView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    var body: some View {
        LazyVStack{
            ForEach(searchViewModel.videos, id:\.self.title) { vid in
                SearchRowView(video: vid)
                    .padding(.horizontal)
                    .contextMenu(ContextMenu(menuItems: {
                        VStack{
                            Button(action: {
                                settingsViewModel.play(for: vid.url, audioOnly: true)
                            }, label: {
                                Label("Play Audio", systemImage: "music.note")
                            })
                            
                            Divider()
                            
                            Button(action: {
                                settingsViewModel.play(for: vid.url)
                            }, label: {
                                Label("Play Video", systemImage: "tv")
                            })
                            
                            Divider()
                            
                            Button(action: {
                                NSWorkspace.shared.open(vid.url)
                            }, label: {
                                Label("Open in youtube.com", systemImage: "globe")
                            })
                        }
                    }))
            }
        }
    }
}

struct SearchedVideosView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedVideosView()
            .environmentObject(SearchViewModel())
    }
}
