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
            DisclosureGroup {
                TextField("Playlist ID", text: $appStateViewModel.playListID)
                    .textFieldStyle(.plain)
                    .thinRoundedBG()
            } label: {
                Label("Custom Playlist ID", systemImage: "music.note.list")
                    .bold()
            }
            .thinRoundedBG()

            Divider()
                .opacity(0.5)

            DisclosureGroup {
                VStack {
                    SpacedToggle("Use IINA", $appStateViewModel.useIINA)

                    Picker("Double Click to", selection: $appStateViewModel.vidClickBehaviour) {
                        ForEach(VideoClickBehaviour.allCases, id: \.self) { behaviour in
                            if behaviour != .playInIINA || appStateViewModel.useIINA {
                                Text(behaviour.rawValue).tag(behaviour)
                            }
                        }
                    }
                }
                .thinRoundedBG()
            } label: {
                Label("Player Settings", systemImage: "play.rectangle.on.rectangle.fill")
                    .bold()
            }
            .thinRoundedBG()
        }
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
