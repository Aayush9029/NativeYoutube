//
//  VideoRow.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-15.
//

import SwiftUI
import SDWebImageSwiftUI

struct VideoRow: View {
    let video: Video
    @State private var hovered = false
    
    var body: some View {
        HStack{
            WebImage(url: video.thumbnail)
                .resizable()
                .placeholder(Image(systemName: "photo"))
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .frame(width: 128, height: 72)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(hovered ? Color.red : .gray.opacity(0.25), lineWidth: 2)
                            .shadow(color: hovered ? .black : .black.opacity(0.25), radius: 5, x: 5, y: 0.0)
                )
            
            VStack(alignment: .leading) {
                Text(video.cleanTitle)
                    .font(.title3.bold())
                    .lineLimit(1)
                
                Text(video.channelTitle)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
            }.padding(.leading, 10)
            Spacer()
        }
        .frame(width: 300, height: 75, alignment: .center)
        .background(hovered ? Color.pink.opacity(0.5) : Color.white.opacity(0.025))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10)
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


struct VideoRow_Previews: PreviewProvider {
    static var previews: some View {
        VideoRow(video: Video.exampleData)
            .padding()
    }
}
