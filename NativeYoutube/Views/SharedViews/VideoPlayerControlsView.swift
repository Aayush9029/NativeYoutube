//
//  VideoPlayerControlsView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI

struct VideoPlayerControlsView: View {
    @StateObject var viewModel: VideoPlayerControlsViewModel

    var body: some View {
        HStack {
            Group {
                Button(action: {
                    viewModel.apply(.prevVideo)
                }, label: {
                    Label("Previous video", systemImage: "backward.end")
                })
                .buttonStyle(VideoPlayerControlsButtonStyle())

                switch viewModel.playbackState {
                case .playing:
                    Button(action: {
                        viewModel.apply(.pauseVideo)
                    }, label: {
                        Label("Pause video", systemImage: "pause")
                    })
                    .buttonStyle(VideoPlayerControlsButtonStyle())

                case .buffering:
                    ProgressView()
                        .controlSize(.small)
                        .padding(6)

                case .paused:
                    Button(action: {
                        viewModel.apply(.playVideo)
                    }, label: {
                        Label("Play video", systemImage: "play")
                    })
                    .buttonStyle(VideoPlayerControlsButtonStyle())

                default:
                    Button(action: {
                        viewModel.apply(.playVideo)
                    }, label: {
                        Label("Play pause video", systemImage: "circle")
                    })
                    .buttonStyle(VideoPlayerControlsButtonStyle())
                }

                Button(action: {
                    viewModel.apply(.nextVideo)
                }, label: {
                    Label("Next video", systemImage: "forward.end")
                })
                .buttonStyle(VideoPlayerControlsButtonStyle())
            }

            Spacer()

            Group {
                Text(String(timeInterval: viewModel.seekbar))

                Slider(value: $viewModel.seekbar, in: 0...viewModel.duration) {
                    viewModel.apply(.seeking($0))
                }
                .controlSize(.mini)

                Text(String(timeInterval: viewModel.duration))
            }

            Spacer()

            Group {
                Button(action: {
                    viewModel.isMuted ? viewModel.apply(.unmuteVideo) : viewModel.apply(.muteVideo)
                }, label: {
                    Label("Toggle Mute", systemImage: viewModel.isMuted ? "speaker.slash" : "speaker.wave.3")
                })
                .buttonStyle(VideoPlayerControlsButtonStyle())

                if !viewModel.isMuted {
                    Slider(value: $viewModel.volume, in: 0...100) {
                        viewModel.apply(.changingVolume($0))
                    }
                    .frame(width: 80)
                    .controlSize(.mini)
                }

                Button(action: {
                    switch viewModel.playbackRate {
                    case .normal:
                        viewModel.apply(.playbackRate(.slow))
                    case .fast:
                        viewModel.apply(.playbackRate(.normal))
                    case .slow:
                        viewModel.apply(.playbackRate(.fast))
                    }
                }, label: {
                    Label("Change playback speed", systemImage: viewModel.playbackRate.rawValue)
                })
                .frame(width: 26)
                .buttonStyle(VideoPlayerControlsButtonStyle())
            }
        }
        .symbolVariant(.fill)
        .labelStyle(.iconOnly)
        .animation(.easeIn(duration: 0.25), value: viewModel.isMuted)
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

struct VideoPlayerControlsButtonStyle: ButtonStyle {
    @State private var isHovering: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(6)
            .background(isHovering ? .ultraThickMaterial : .ultraThinMaterial)
            .cornerRadius(8)
            .onHover {
                isHovering = $0
            }
            .animation(.easeIn(duration: 0.10), value: isHovering)
    }
}
