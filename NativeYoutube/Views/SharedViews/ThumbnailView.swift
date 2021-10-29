//
//  ThumbnailView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct ThumbnailView: View {
    let url: URL?
    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "play.fill")
                .font(.largeTitle)
        }
        .frame(width: 128, height: 72)
        .cornerRadius(5)
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(url: PlayListModel.exampleData.thumbnail)
    }
}
