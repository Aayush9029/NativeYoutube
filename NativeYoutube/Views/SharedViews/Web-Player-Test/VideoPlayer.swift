//
//  VideoPlayer.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-30.
//


// THIS IS NOT BEING COMPILED AS IT IS NOT BEING USED RN... 0.0

import SwiftUI
import WebKit

struct VideoPlayer: View {
    let videoUrl: URL
    var body: some View {
        SafariWebView(mesgURL: videoUrl.absoluteString)
    }
}

struct VideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayer(videoUrl: SearchModel.exampleData.url)
    }
}
