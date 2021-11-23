//
//  CustomContextMenuView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI

struct CustomContextMenuView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @EnvironmentObject var youtubePlayerViewModel: YoutubePlayerViewModel
    let videoUrl: URL
    let videoTitle: String
    var body: some View {
        Group{
            VStack{
                Button(action: {
                    settingsViewModel.currentlyPlaying = videoTitle
                    settingsViewModel.playAudioYTDL(url: videoUrl, title: videoTitle)
                }, label: {
                    Label("Play Audio in IINA", systemImage: "music.note")
                })
                Button {
                    settingsViewModel.togglePlaying(videoTitle)
                    youtubePlayerViewModel.playVideo(url: videoUrl.absoluteString)
                } label: {
                    Label("Play Video", systemImage: "play.circle")
                }

                Divider()
                Button(action: {
                    NSWorkspace.shared.open(videoUrl)
                }, label: {
                    Label("Open in youtube.com", systemImage: "globe")
                })
            }
        }
    }
}
