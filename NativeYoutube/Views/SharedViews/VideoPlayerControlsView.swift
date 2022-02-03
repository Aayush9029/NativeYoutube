//
//  VideoPlayerControlsView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI

struct VideoPlayerControlsView: View {
    @ObservedObject var viewModel: VideoPlayerControlsViewModel

    var body: some View {
        HStack{
            Group{
                VideoPlayerControlsButtonView(title: "Previous video", image: "backward.end")
                    .onTapGesture {
                        viewModel.apply(.prevVideo)
                    }
                switch viewModel.playbackState {
                case .playing:
                    VideoPlayerControlsButtonView(title: "Pause video", image: "pause")
                        .onTapGesture {
                            viewModel.apply(.pauseVideo)
                        }
                case .buffering:
                    ProgressView()
                        .controlSize(.small)
                case .paused:
                    VideoPlayerControlsButtonView(title: "Play video", image: "play")
                        .onTapGesture {
                            viewModel.apply(.playVideo)
                        }
                default:
                    VideoPlayerControlsButtonView(title: "Play pause video", image: "circle")
                        .onTapGesture {
                            viewModel.apply(.playVideo)
                        }
                }

                VideoPlayerControlsButtonView(title: "Next video", image: "forward.end")
                    .onTapGesture {
                        viewModel.apply(.nextVideo)
                    }
            }

            Spacer()

            Group {
                Text(viewModel.currentDuration)
                Slider(value: $viewModel.seekbar, in: 0...1.0, onEditingChanged: { isSeeking in
                    viewModel.apply(.seeking(isSeeking))
                })
                Text(String(timeInterval: viewModel.endDuration))
            }

            Spacer()

            Group{
                VideoPlayerControlsButtonView(title: "Toggle Mute", image: viewModel.isMuted ? "speaker.slash": "speaker.wave.3")
                    .onTapGesture {
                        viewModel.isMuted ? viewModel.apply(.unmuteVideo) : viewModel.apply(.muteVideo)
                    }
                VideoPlayerControlsButtonView(title: "Change playback speed", image: viewModel.playbackRate.rawValue)
                    .onTapGesture {
                        switch viewModel.playbackRate {
                        case .normal:
                            viewModel.apply(.playbackRate(.slow))
                        case .fast:
                            viewModel.apply(.playbackRate(.normal))
                        case .slow:
                            viewModel.apply(.playbackRate(.fast))
                        }
                    }
            }
        }
        .symbolVariant(.fill)
        .labelStyle(.iconOnly)
        .onAppear {
            viewModel.apply(.onAppear)
        }
    }
}

struct VideoPlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerControlsView(viewModel: .init(youtubePlayer: YoutubePlayerViewModel.exampleVideo))
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
