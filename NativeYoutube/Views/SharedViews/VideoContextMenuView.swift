//
//  VideoContextMenuView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI

struct VideoContextMenuView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @EnvironmentObject var youtubePlayerViewModel: YoutubePlayerViewModel

    let video: VideoModel

    var body: some View {
        Group {
            VStack {
                Button(action: {
                    appStateViewModel.playAudioYTDL(url: video.url, title: video.title)
                }, label: {
                    Label("Play Audio in IINA", systemImage: "music.note")
                })
                Button {
                    appStateViewModel.togglePlaying(video.title)
                    youtubePlayerViewModel.playVideo(url: video.url.absoluteString)
                } label: {
                    Label("Play Video", systemImage: "play.circle")
                }

                Divider()
                Button(action: {
                    NSWorkspace.shared.open(video.url)
                }, label: {
                    Label("Open in youtube.com", systemImage: "globe")
                })
            }
        }
    }
}

// struct VideoContextMenu_Preview: PreviewProvider {
//    static var previews: some View {
//        VideoContextMenuView(video: .exampleData)
//            .environmentObject(AppStateViewModel())
//            .environmentObject(YoutubePlayerViewModel())
//            .frame(width: 350)
//    }
// }
