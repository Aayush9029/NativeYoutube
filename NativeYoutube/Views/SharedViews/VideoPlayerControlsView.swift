//
//  VideoPlayerControlsView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayerControlsView: View {
    @State var youtubePlayer: YouTubePlayer
    
    @State private var isMuted: Bool = false
    @State private var playbackRate: PlaybackRate = .normal

    var body: some View {
        HStack{
            Group{
                
                VideoPlayerControlsButtonView(title: "Previous video", image: "backward.end")
                    .onTapGesture {
                        youtubePlayer.previousVideo()
                    }
                switch youtubePlayer.playbackState{
                case .playing:
                    VideoPlayerControlsButtonView(title: "Pause video", image: "pause")
                        .onTapGesture {
                            youtubePlayer.pause()
                        }
                case .buffering:
                    ProgressView()
                case .paused:
                    VideoPlayerControlsButtonView(title: "Play video", image: "play")
                        .onTapGesture {
                            youtubePlayer.play()
                        }
                default:
                    VideoPlayerControlsButtonView(title: "Play pause video", image: "circle")
                        .onTapGesture {
                            youtubePlayer.play()
                        }
                }

                VideoPlayerControlsButtonView(title: "Next video", image: "forward.end")
                    .onTapGesture {
                        youtubePlayer.nextVideo()
                    }
            }
            Spacer()
            Group{
//                VideoPlayerControlsButtonView(title: "Toggle Mute", image: isMuted ? "speaker.slash": "speaker")
//                    .onTapGesture {
//                        isMuted ? youtubePlayer.unmute() : youtubePlayer.mute()
//                    }
                VideoPlayerControlsButtonView(title: "Change playback speed", image: playbackRate.rawValue)
                    .onTapGesture {
                        switch playbackRate {
                        case .normal:
                            youtubePlayer.set(playbackRate: 1.0)
                            playbackRate = .slow
                        case .fast:
                            youtubePlayer.set(playbackRate: 2.0)
                            playbackRate = .normal
                        case .slow:
                            youtubePlayer.set(playbackRate: 0.5)
                            playbackRate = .fast

                        }
                    }
            }
        }
        .symbolVariant(.fill)
        .labelStyle(.iconOnly)
    }
}

struct VideoPlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerControlsView(youtubePlayer: YoutubePlayerViewModel.exampleVideo)
    }
}


extension VideoPlayerControlsView{
    enum PlaybackRate: String{
        case normal = "speedometer"
        case fast = "hare"
        case slow = "tortoise"
    }
}


struct VideoPlayerControlsButtonView: View {
    let title: String
    let image: String
    @State private var isHovering: Bool = false
    var body: some View {
        Label(title, systemImage: image)
            .padding(6)
            .background(isHovering ? .ultraThickMaterial : .ultraThinMaterial)
            .cornerRadius(8)
    }
}
