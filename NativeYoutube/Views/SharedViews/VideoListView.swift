//
//  VideoListView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SwiftUI

struct VideoListView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var youtubePlayerViewModel: YoutubePlayerViewModel

    let videos: [VideoModel]

    var body: some View {
        Group {
            if videos.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128)
                        .padding()
                    Text("Search for a Video")
                        .font(.title3)
                }
                .foregroundStyle(.quaternary)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(videos, id: \.self.id) { video in
                        VideoRowView(video: video)
                            .contextMenu(ContextMenu(menuItems: {
                                VideoContextMenuView(video: video)
                            }))
                        // On double tap gesture, make the action according to user's preferences.
                            .onTapGesture(count: 2) {
                                switch appStateViewModel.vidClickBehaviour {
                                case .nothing:
                                    return
                                case .playVideo:
                                    appStateViewModel.togglePlaying(video.title)
                                    youtubePlayerViewModel.playVideo(url: video.url, appState: appStateViewModel)
                                case .openOnYoutube:
                                    NSWorkspace.shared.open(video.url)
                                case .playInIINA:
                                    appStateViewModel.playVideoIINA(url: video.url, title: video.title)
                                }
                            }
                    }
                    .padding(.horizontal, 6)
                    .padding(.top, 6)
                }
            }
        }
    }
}

struct VideowListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(videos: [])
            .environmentObject(AppStateViewModel())
    }
}
