//
//  PopupPlayerView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import AVKit
import SwiftUI
import YouTubeKit
import YouTubePlayerKit

struct PopupPlayerView: View {
    // As view is displayed via a function, can't use EnvironnementObject -> Re-declaring useNativePlayer var in the view.
    @ObservedObject var appStateViewModel: AppStateViewModel

    let videoURL: URL
    @State var player: AVPlayer? = nil
    @State var isHoveringOnPlayer = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                if player != nil {
                    VideoPlayer(player: player)
                } else {
                    VStack {
                        ProgressView()
                        Text("\(appStateViewModel.currentlyPlaying)")
                            .frame(width: 420)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.tertiary)
                            .padding()
                    }
                    .padding()
                    .frame(width: 600, height: 400)
                    .background(.black)
                }
            }

            if isHoveringOnPlayer {
                PopUpPlayerCloseButton()
                    .onTapGesture {
                        appStateViewModel.stopPlaying()
                        NSApp.keyWindow?.close()
                    }
            }
        }
        .task {
            // We need to get the video's stream in async, so we set a task who runs when view appears to set the value of the player to the video stream.
            let video = YouTube(url: videoURL)
            do {
                let streams = try await video.streams
                let streamHQ = streams
                    .filter { $0.isProgressive }
                    .highestResolutionStream()?.url
                if let streamHQ {
                    player = AVPlayer(url: streamHQ)
                }
                player?.play()
            } catch {}
        }
        .onHover { hovering in
            withAnimation {
                isHoveringOnPlayer = hovering
            }
        }
        .background(VisualEffectView(material: .popover, blendingMode: .behindWindow))
        .cornerRadius(10)
        .frame(minWidth: 320, maxWidth: 1600, minHeight: 180, maxHeight: 900)
        .aspectRatio(16/9, contentMode: .fit)
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
