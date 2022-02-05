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
    @State var isHoveringOnPlayer = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack{
                VideoPlayerView(youtubePlayer: youtubePlayer)
                    .cornerRadius(20)
                    .onHover { hovering in
                        withAnimation {
                            isHoveringOnPlayer = hovering
                        }
                    }
                
                VideoPlayerControlsView(viewModel: .init(youtubePlayer: youtubePlayer))
                    .padding(.horizontal)
                    .padding(.bottom, 5)
            }
            
            if isHoveringOnPlayer {
                PopUpPlayerCloseButton()
                    .onTapGesture {
                        NSApp.keyWindow?.close()
                    }
            }
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}

// MARK: - Close Button for Popup Player

struct PopUpPlayerCloseButton: View {
    var body: some View{
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
