//
//  VideoRowView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SDWebImageSwiftUI
import SwiftUI

struct VideoRowView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @State private var focused: Bool = false

    let video: VideoModel

    var body: some View {
        Group {
            ZStack {
                WebImage(url: video.thumbnail)
                    .resizable()
                    .overlay {
                        Rectangle()
                            .fill(focused ? .ultraThinMaterial : .ultraThickMaterial)
                    }

                HStack {
                    if !focused {
                        WebImage(url: video.thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110)
                            .cornerRadius(4)
                            .shadow(radius: 6, x: 2)
                            .padding(4)

                            .transition(.offset(x: -130))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(video.title)
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                            .bold()
                            .lineLimit(focused ? 3 : 1)

                        Text(video.channelTitle)
                            .foregroundStyle(.secondary)
                            .font(focused ? .caption : .footnote)

                        if !focused {
                            Text(video.publishedAt)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.leading, focused ? 6 : 0)
                    Spacer()
                }
            }
            .clipped()
            .frame(height: 80)
            .containerShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(focused ? Color.pink : .gray.opacity(0.25), lineWidth: 2)
                .shadow(color: focused ?.pink : .blue.opacity(0), radius: 10)
            )
            .onTapGesture(count: 2) {
                switch appStateViewModel.vidClickBehaviour {
                case .nothing:
                    return
                case .playVideo:
                    appStateViewModel.togglePlaying(video.title)
                    playVideo(url: video.url, appState: appStateViewModel)
                case .openOnYoutube:
                    NSWorkspace.shared.open(video.url)
                case .playInIINA:
                    appStateViewModel.playVideoIINA(url: video.url, title: video.title)
                }
            }
            .onTapGesture(perform: {
                focused.toggle()
            })
            .animation(.easeIn, value: focused)
        }
        .onHover { hoverState in
            if focused && !hoverState {
                focused.toggle()
            }
        }
    }
}

struct VideoRowView_Previews: PreviewProvider {
    static var previews: some View {
        VideoRowView(video: VideoModel.exampleData)
            .environmentObject(AppStateViewModel())
    }
}
