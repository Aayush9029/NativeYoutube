//
//  YoutubePreferenceView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI

struct YoutubePreferenceView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                DisclosureGroup {
                    VStack(alignment: .leading) {
                        TextField("Your Google API Key", text: $appStateViewModel.apiKey)
                            .textFieldStyle(.plain)
                            .thinRoundedBG()

                        Link(
                            destination: URL(string: Constants.demoYoutubeVideo)!,
                            label: {
                                HStack {
                                    Spacer()
                                    Label("How to get Google API Key?", systemImage: "globe")
                                    Spacer()
                                }
                            }
                        )
                    }

                } label: {
                    Label("Your Youtube API Key", systemImage: "person.badge.key.fill")
                        .bold()
                }
            }
            .thinRoundedBG()
        }
    }
}

struct PreferenceAPIView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubePreferenceView()
            .environmentObject(AppStateViewModel())
    }
}
