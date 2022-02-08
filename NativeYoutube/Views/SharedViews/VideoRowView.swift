//
//  VideoRowView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SwiftUI

struct VideoRowView: View {
    let video: VideoModel

    @State var isHovered: Bool = false

    var body: some View {
        Group {
            HStack {
                ThumbnailView(url: video.thumbnail)

                VStack(alignment: .leading, spacing: 2) {
                    Text(video.title)
                        .foregroundStyle(.primary)
                        .font(.title3.bold())
                        .lineLimit(1)

                    Text(video.publishedAt)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    Text(video.channelTitle)
                        .foregroundStyle(.tertiary)
                        .font(.caption)
                }
                .padding(.leading, 10)

                Spacer()
            }
            .background(isHovered ? Color.pink.opacity(0.5) : Color.white.opacity(0.025))
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(isHovered ? Color.pink : .gray.opacity(0.25), lineWidth: 2)
                        .shadow(color: isHovered ?.pink : .blue.opacity(0), radius: 10)
            )
            .animation(.default, value: isHovered)
            .onHover { isHovered in
                self.isHovered = isHovered
            }
        }
    }
}

struct VideoRowView_Previews: PreviewProvider {
    static var previews: some View {
        VideoRowView(video: VideoModel.exampleData)
    }
}
