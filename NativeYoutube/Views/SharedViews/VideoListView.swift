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
            if videos.isEmpty {
                VStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 128)
                        .padding()
                    Text("Search for a Video")
                        .font(.title3)
                }
                .foregroundStyle(.quaternary)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(videos, id: \.self.id) { vid in
                        VideoRowView(video: vid)
                            .contextMenu(ContextMenu(menuItems: {
                                VideoContextMenuView(video: vid)
                            }))
                    }
                    .padding(.horizontal)
                    .padding(.top, 6)
                }
            }
        }
    }
}

struct VideowListView_Previews: PreviewProvider {
    static var previews: some View {
        VideoListView(videos: [])
            .environmentObject(AppStateViewModel())
    }
}
