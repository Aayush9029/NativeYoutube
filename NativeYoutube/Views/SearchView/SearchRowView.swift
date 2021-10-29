//
//  SearchRowView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SearchRowView: View {
    @State private var hovered = false
    var video: SearchModel
    
    var body: some View {
        HStack{
            ThumbnailView(url: video.thumbnail)
                .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(hovered ? Color.red : .gray.opacity(0.25), lineWidth: 2)
                            .shadow(color: hovered ? .black : .black.opacity(0.25), radius: 5, x: 5, y: 0.0)
                )

            VStack(alignment: .leading) {
                Text(video.cleanTitle)
                    .font(.title3.bold())
                    .lineLimit(1)
                
                Text(video.publishedAt)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
            }.padding(.leading, 10)
            Spacer()
        }    .background(hovered ? Color.pink.opacity(0.5) : Color.white.opacity(0.025))
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(hovered ? Color.pink : .gray.opacity(0.25), lineWidth: 2)
                        .shadow(color: hovered ?.pink : .blue.opacity(0), radius: 10)
                     
            )
            .padding(.horizontal, 10)
            .animation(.default, value: hovered)
            .onHover { isHovered in
                self.hovered = isHovered
            }
        
    }
}

struct SearchRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchRowView(video: SearchModel.exampleData)
    }
}
