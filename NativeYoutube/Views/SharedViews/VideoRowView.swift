//
//  VideoRowView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SDWebImageSwiftUI
import SwiftUI

struct VideoRowView: View {
    let video: VideoModel

    @State var hovered: Bool = false

    var body: some View {
        Group {
            ZStack {
                WebImage(url: video.thumbnail)
                    .resizable()
                    .overlay {
                        Rectangle()
                            .fill(hovered ? .ultraThinMaterial : .ultraThickMaterial)
                    }

                HStack {
                    if !hovered {
                        WebImage(url: video.thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 72)
                            .cornerRadius(5)
                            .shadow(radius: 6, x: 2)
                            .padding(.leading, 4)
                            .padding(.vertical, 2)
                            .transition(.offset(x: -128))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(video.title)
                            .foregroundStyle(.primary)
                            .bold()
                            .lineLimit(hovered ? 3 : 1)

                        Text(video.channelTitle)
                            .foregroundStyle(.secondary)
                            .font(hovered ? .caption : .footnote)

                        if !hovered {
                            Text(video.publishedAt)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
            }
            .clipped()
            .frame(height: 80)
            .containerShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(hovered ? Color.pink : .gray.opacity(0.25), lineWidth: 2)
                .shadow(color: hovered ?.pink : .blue.opacity(0), radius: 10)
            )
            .onHover { val in
                self.hovered = val
            }
            .animation(.easeInOut, value: hovered)
        }
    }
}

struct VideoRowView_Previews: PreviewProvider {
    static var previews: some View {
        VideoRowView(video: VideoModel.exampleData)
    }
}
