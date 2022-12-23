//
//  VideoContextMenuView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI

struct VideoContextMenuView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    let video: VideoModel

    var body: some View {
        Group {
            Group {
                if appStateViewModel.useIINA {
                    Button(action: {
                        appStateViewModel.playVideoIINA(url: video.url, title: video.title)
                    }, label: {
                        Label("Play Video in IINA", systemImage: "play.circle")
                    })
                    Divider()
                }
            }
            VStack {
                Button {
                    appStateViewModel.togglePlaying(video.title)
                    playVideo(url: video.url, appState: appStateViewModel)

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
