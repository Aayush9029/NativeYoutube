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
    var body: some View {
        VStack{
            VideoPlayerView(youtubePlayer: youtubePlayer)
//            RoundedRectangle(cornerRadius: 10)
                .cornerRadius(20)
            VideoPlayerControlsView(youtubePlayer: youtubePlayer)
                .padding(.horizontal)
                .padding(.bottom, 5)
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
