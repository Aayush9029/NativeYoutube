//
//  YoutubePlayerViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit

class YoutubePlayerViewModel: ObservableObject {
    func playVideo(url: URL, appState: AppStateViewModel) {
        let videoPlayer = YouTubePlayer(source: YouTubePlayer.Source.url(url.absoluteString), configuration: YoutubePlayerViewModel.configuration)
        PopupPlayerView(appStateViewModel: appState, youtubePlayer: videoPlayer, videoURL: url)
            .openNewWindow(isTransparent: true, appState: appState)
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
