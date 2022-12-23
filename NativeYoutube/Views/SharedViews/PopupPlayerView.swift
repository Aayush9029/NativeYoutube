//
//  PopupPlayerView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-11-23.
//

import SwiftUI
import YouTubePlayerKit

struct PopupPlayerView: View {
    @StateObject var youtubePlayer: YouTubePlayer
    @State var isHoveringOnPlayer = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
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

            if isHoveringOnPlayer {
                PopUpPlayerCloseButton()
                    .onTapGesture {
                        NSApp.keyWindow?.close()
                    }
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
        PopupPlayerView(youtubePlayer: YoutubePlayerViewModel.exampleVideo)
    }
}
