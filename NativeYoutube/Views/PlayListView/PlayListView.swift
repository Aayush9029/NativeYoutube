//
//  PlayListView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct PlayListView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    @StateObject var playlistViewModel = PlayListViewModel()

     var body: some View {
         Group {
             switch playlistViewModel.currentStatus {
             case .startedFetching:
                 ProgressView()
             case .none, .doneFetching:
                 VideoListView(videos: playlistViewModel.videos)
             default:
                 SomethingWentWrongView()
             }
         }
         .onAppear {
             playlistViewModel.startFetch(apiKey: appStateViewModel.apiKey, playListID: appStateViewModel.playListID)
         }
         .onChange(of: playlistViewModel.currentStatus) { newValue in
             appStateViewModel.addToLogs(for: Pages.playlists, message: newValue.rawValue)
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
     }
 }

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
            .environmentObject(AppStateViewModel())
            .frame(width: 350)
    }
}
