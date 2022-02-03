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
    @EnvironmentObject var youtubePlayerViewModel: YoutubePlayerViewModel
    var body: some View {
        Group{
            if searchViewModel.currentStatus == .unknownError{
                SomethingWentWrongView()
                    .environmentObject(settingsViewModel)
            } else {
                ForEach(searchViewModel.videos, id:\.self.title) { vid in
                    SearchRowView(video: vid)
                        .padding(.horizontal)
                        .onTapGesture(count: 2, perform: {
                            settingsViewModel.playAudioYTDL(url: vid.url, title: vid.title)
                        })
                        .contextMenu(ContextMenu(menuItems: {
                            CustomContextMenuView(videoUrl: vid.url, videoTitle: vid.title)
                                .environmentObject(youtubePlayerViewModel)
                                .environmentObject(settingsViewModel)
                        }))
                }
            }
        }
    }
}

struct SearchedVideosView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedVideosView()
            .environmentObject(SettingsViewModel())
            .environmentObject(SearchViewModel())
    }
}
