//
//  GeneralPreferenceView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI
import YouTubeKit

struct GeneralPreferenceView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Label("Custom Playlist ID", systemImage: "music.note.list")
                .bold()

            TextField("Playlist ID", text: $appStateViewModel.playListID)
                .textFieldStyle(.plain)
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(6)

            Toggle("Use IINA", isOn: $appStateViewModel.useIINA)
                .toggleStyle(.switch)
                .bold()
            
            Toggle("Use native player", isOn: $appStateViewModel.useNativePlayer)
                .toggleStyle(.switch)
                .bold()
            
            Picker("When double click on a video...", selection: $appStateViewModel.vidClickBehaviour) {
                Text("Do nothing").tag(VideoClickBehaviour.nothing)
                Text("Play video").tag(VideoClickBehaviour.playVideo)
                Text("Open on YouTube").tag(VideoClickBehaviour.openOnYoutube)
                if appStateViewModel.useIINA {
                    Text("Play video in IINA").tag(VideoClickBehaviour.playInIINA)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(6)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPreferenceView()
    }
}
