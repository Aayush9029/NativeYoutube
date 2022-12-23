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

            SpacedToggle("Use IINA", $appStateViewModel.useIINA)

            Picker("Double Click to", selection: $appStateViewModel.vidClickBehaviour) {
                ForEach(VideoClickBehaviour.allCases, id: \.self) { behaviour in
                    if behaviour != .playInIINA || appStateViewModel.useIINA {
                        Text(behaviour.rawValue).tag(behaviour)
                    }
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

struct SpacedToggle: View {
    let title: String
    @Binding var binded: Bool

    init(_ title: String = "", _ isOn: Binding<Bool>) {
        self.title = title
        self._binded = isOn
    }

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $binded)
                .toggleStyle(.switch)
                .bold()
        }
    }
}
