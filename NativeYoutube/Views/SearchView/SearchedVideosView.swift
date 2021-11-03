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
            if searchViewModel.currentStatus == .unknownError{
                SomethingWentWrongView()
                    .environmentObject(settingsViewModel)
            }
            ForEach(searchViewModel.videos, id:\.self.title) { vid in
                SearchRowView(video: vid)
                    .padding(.horizontal)
                    .onTapGesture(count: 2, perform: {
                        settingsViewModel.playAudioYTDL(url: vid.url, title: vid.title)
                    })
                    .contextMenu(ContextMenu(menuItems: {
                        VStack{
                            Button(action: {
                                settingsViewModel.playAudioYTDL(url: vid.url, title: vid.title)
                            }, label: {
                                Label("Play Audio in IINA", systemImage: "music.note")
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
