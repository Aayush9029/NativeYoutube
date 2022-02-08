//
//  YoutubePlayerViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit

class YoutubePlayerViewModel: ObservableObject {
    @Published var currentVideo: YouTubePlayer?

    func playVideo(url: String) {
        currentVideo = YouTubePlayer.init(source: YouTubePlayer.Source.url(url), configuration: YoutubePlayerViewModel.configuration)
        PopupPlayerView(youtubePlayer: currentVideo ?? YoutubePlayerViewModel.exampleVideo)
            .openNewWindow(isTransparent: true)
    }

    static let configuration = YouTubePlayer.Configuration(
        isUserInteractionEnabled: false,
        allowsPictureInPictureMediaPlayback: true,
        autoPlay: true,
        showControls: false,
        keyboardControlsDisabled: false,
        enableJavaScriptAPI: true,
        loopEnabled: true,
        showRelatedVideos: false
    )
}

// MARK: - Example video data
extension YoutubePlayerViewModel {
    static let exampleVideo = YouTubePlayer(
        source: .video(id: "LDU_Txk06tM"),
        configuration:
            YoutubePlayerViewModel.configuration
    )
}
