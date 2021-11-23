//
//  PlayListView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct PlayListView: View {
    @EnvironmentObject var playlistViewModel: PlayListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var youtubePlayerViewModel: YoutubePlayerViewModel

     var body: some View {
         VStack{
             if playlistViewModel.currentStatus == .unknownError{
                 SomethingWentWrongView()
                     .environmentObject(settingsViewModel)
             }
             ScrollView(.vertical, showsIndicators: false){
                 ForEach(playlistViewModel.videos, id:\.self.title) { vid in
                     PlaylistRowView(video: vid)
                         .onTapGesture(count: 2, perform: {
                             settingsViewModel.playAudioYTDL(url: vid.url, title: vid.title)
                         })
                         .contextMenu(ContextMenu(menuItems: {
                             CustomContextMenuView(videoUrl: vid.url, videoTitle: vid.title)
                                 .environmentObject(youtubePlayerViewModel)
                                 .environmentObject(settingsViewModel)
                         }))
                 }
             }.padding()
         }
         .onAppear {
             playlistViewModel.startFetch()
         }
     }
 }

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
            .environmentObject(PlayListViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(YoutubePlayerViewModel())
            .frame(width: 350)
    }
}
