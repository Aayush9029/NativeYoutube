//
//  PreferencesView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI

struct PreferencesView: View {
    var body: some View {
        VStack(alignment: .leading) {
            GeneralPreferenceView()

            Divider()
                .opacity(0.25)

            YoutubePreferenceView()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

struct PreferencesView_Preview: PreviewProvider {
    static var previews: some View {
        PreferencesView()
            .environmentObject(AppStateViewModel())
    }
}
