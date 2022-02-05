//
//  PopupPlayerView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit

struct PopupPlayerView: View {
    let youtubePlayer: YouTubePlayer
    @State var isHoveringOnPlayer = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack{
                VideoPlayerView(youtubePlayer: youtubePlayer)
                    .cornerRadius(20)
                    .onHover { hovering in
                        withAnimation {
                            isHoveringOnPlayer = hovering
                        }
                    }

                VideoPlayerControlsView(viewModel: .init(youtubePlayer: youtubePlayer))
                    .padding(.horizontal)
                    .padding(.bottom, 5)
            }

            if isHoveringOnPlayer {
                Button(role: .cancel) {
                    NSApp.keyWindow?.close()
                } label: {
                    Label("Close", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .foregroundColor(.secondary)
                }
                .background(.ultraThickMaterial)
                .frame(width: 28, height: 28)
                .offset(x: 28/2, y: 28/2)
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

struct PopupPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PopupPlayerView(youtubePlayer: YoutubePlayerViewModel.exampleVideo)
    }
}
