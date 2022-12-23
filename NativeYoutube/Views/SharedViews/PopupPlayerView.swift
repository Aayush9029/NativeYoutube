//
//  PopupPlayerView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit
import AVKit
import YouTubeKit

struct PopupPlayerView: View {
    //As view is displayed via a function, can't use EnvironnementObject -> Re-declaring useNativePlayer var in the view.
    @AppStorage(AppStorageStrings.useNativePlayer.rawValue) var useNativePlayer: Bool = true
    
    @StateObject var youtubePlayer: YouTubePlayer
    
    let videoURL: URL
    @State var player: AVPlayer? = nil
    @State var isHoveringOnPlayer = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack {
                if useNativePlayer {
                    if player != nil {
                        ZStack {
                            VideoPlayer(player: player)
                        }
                    } else {
                        ProgressView().frame(width: 600, height: 400)
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                        VideoPlayerView(youtubePlayer: youtubePlayer)
                    }
                    if isHoveringOnPlayer {
                        VideoPlayerControlsView(viewModel: .init(youtubePlayer: youtubePlayer))
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                    }
                }
                
                
            }

            if isHoveringOnPlayer {
                PopUpPlayerCloseButton()
                    .onTapGesture {
                        NSApp.keyWindow?.close()
                    }
            }
        }
        .task {
            if useNativePlayer {
                //We need to get the video's stream in async, so we set a task who runs when view appears to set the value of the player to the video stream.
                let video = YouTube(url: videoURL)
                do {
                    let streams = try await video.streams
                    //Even though it should return the highest resolution stream for the video, as AVPlayer doesn't support DASH streams, it returns a not-that-great quality stream
                    player = AVPlayer(url: streams
                        .filter { $0.isProgressive }
                        .highestResolutionStream()!.url)
                    // we need to start playback as it doesn't play automatically
                    player!.play()
                } catch {}
            }
        }
        .onHover { hovering in
            withAnimation {
                isHoveringOnPlayer = hovering
            }
        }
        .background(VisualEffectView(material: .popover, blendingMode: .behindWindow))
        .cornerRadius(10)
        .frame(minWidth: 480, minHeight: 270)
    }
}

// MARK: - Close Button for Popup Player

struct PopUpPlayerCloseButton: View {
    var body: some View {
        Label("Close", systemImage: "xmark")
            .font(.title3.bold())
            .labelStyle(.iconOnly)
            .foregroundColor(.secondary)
            .padding(8)
            .background(VisualEffectView(material: .hudWindow, blendingMode: .withinWindow))
            .clipShape(Circle())
            .frame(width: 28, height: 28)
            .offset(x: 28/2, y: 28/2)
    }
}

struct PopupPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PopupPlayerView(youtubePlayer: YoutubePlayerViewModel.exampleVideo, videoURL: URL(string: "https://www.youtube.com/watch?v=EgBJmlPo8Xw")!)
    }
}
