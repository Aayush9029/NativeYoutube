//
//  GeneralPreferenceView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI

struct GeneralPreferenceView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    @AppStorage(AppStorageStrings.playListID.rawValue) var playListID = Constants.defaultPlaylistID

    var body: some View {
        VStack(alignment: .leading) {
            Text("Custom Playlist ID")
                .font(.title3.bold())
                .padding(.top)

            TextField("Playlist ID", text: $playListID)
                .padding([.bottom], 10)
                .textFieldStyle(.roundedBorder)

            Divider()

            HStack {
                Text("Use IINA for video playback")
                    .font(.title3.bold())
                Spacer()
                Toggle(isOn: $appStateViewModel.useIINA) {}
                    .toggleStyle(.switch)
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
        .frame(width: 350)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralPreferenceView()
    }
}
