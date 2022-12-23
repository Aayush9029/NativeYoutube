//
//  VideoRowView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SwiftUI

struct VideoRowView: View {
    let video: VideoModel

    @State var hovered: Bool = false

    var body: some View {
        Group {
            ZStack {
                AsyncImage(url: video.thumbnail, content: { image in
                    image
                        .resizable()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(hovered ? .ultraThinMaterial : .ultraThickMaterial)
                        }
                }, placeholder: {
                    Spacer()
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(hovered ? .ultraThinMaterial : .ultraThickMaterial)
                        }
                })

                HStack() {
                    AsyncImage(url: video.thumbnail, content: { image in
                        image
                            .resizable()
                            .scaledToFill()
                        // When hovered, reduce size of the thumbnail...
                            .frame(width: hovered ? 64 : 128, height: hovered ? 36 : 72)
                            .cornerRadius(5)
                            .shadow(radius: 6, x: 2)
                        // ...and move it a bit on the left to avoid looking weird.
                            .padding(.leading, hovered ? 10 : 4)
                            .padding(.vertical, 2)
                            .transition(.offset(x: -128))
                    }, placeholder: {
                        ProgressView().scaleEffect(0.2)
                            .frame(width: hovered ? 64 : 128, height: hovered ? 36 : 72)
                    })

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
            //added a Mask to avoid weird behaviours with the colored background of the row
            .mask {
                RoundedRectangle(cornerRadius: 5)
            }
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
