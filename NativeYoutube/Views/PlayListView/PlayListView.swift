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
                             settingsViewModel.play(for: vid.url)
                         })
                         .contextMenu(ContextMenu(menuItems: {
                             VStack{
                                 Button(action: {
                                     settingsViewModel.play(for: vid.url, audioOnly: true)
                                 }, label: {
                                     Text("Play Audio")
                                 })
                                 Button(action: {
                                     settingsViewModel.play(for: vid.url)
                                 }, label: {
                                     Text("Play Video")
                                 })
                             }
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
    }
}
