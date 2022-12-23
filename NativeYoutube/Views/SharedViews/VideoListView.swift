//
//  VideoListView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SwiftUI

struct VideoListView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    let videos: [VideoModel]

    var body: some View {
        Group {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(videos, id: \.self.id) { vid in
                    VideoRowView(video: vid)
                        .contextMenu(ContextMenu(menuItems: {
                            VideoContextMenuView(video: vid)
                        }))
                }
                .padding()
            }
        }
    }
}

struct VideowListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(videos: [.exampleData, .exampleData])
            .environmentObject(AppStateViewModel())
    }
}
