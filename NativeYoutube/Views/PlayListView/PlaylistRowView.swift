//
//  PlaylistRowView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct PlaylistRowView: View {
    let video: PlayListModel
    
    @State var isHovered: Bool = false
    var body: some View {
        Group{
            HStack{
                ThumbnailView(url: video.thumbnail)
                
                VStack(alignment: .leading) {
                    Text(video.cleanTitle)
                        .font(.title3.bold())
                        .lineLimit(1)
                    
                    Text(video.publishedAt)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                }.padding(.leading, 10)
                Spacer()
            }    .background(isHovered ? Color.pink.opacity(0.5) : Color.white.opacity(0.025))
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

struct PlaylistRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistRowView(video: PlayListModel.exampleData)
    }
}
