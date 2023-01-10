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
    @State var focused: Bool = false

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
                            .frame(width: 128, height: 72)
                            .cornerRadius(5)
                            .shadow(radius: 6, x: 2)
                            .padding(.leading, 4)
                            .padding(.vertical, 2)
                            .transition(.offset(x: -130))
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(video.title)
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
                    .padding(.leading, 10)
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
            .onTapGesture(perform: {
                focused.toggle()
            })
            .animation(.easeInOut, value: focused)
        }
    }
}

struct VideoRowView_Previews: PreviewProvider {
    static var previews: some View {
        VideoRowView(video: VideoModel.exampleData)
    }
}
