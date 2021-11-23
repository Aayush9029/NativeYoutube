//
//  VideoPlayerView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayerView: View {
    let youtubePlayer: YouTubePlayer
    var body: some View {
        YouTubePlayerView(self.youtubePlayer){ state in
            switch state{
            case .idle:
                ProgressView()
            case .ready:
                EmptyView()
            case .error(let error):
                Text(verbatim: "Youtube video player couldn't be loaded \(error)")
            }
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(youtubePlayer: YoutubePlayerViewModel.exampleVideo)
    }
}
