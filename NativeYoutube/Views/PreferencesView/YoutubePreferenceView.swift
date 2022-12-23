//
//  YoutubePreferenceView.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/4/22.
//

import SwiftUI

struct YoutubePreferenceView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @StateObject var youtubePreferenceViewModel = YoutubePreferenceViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Label("Your Youtube API Key", systemImage: "person.badge.key.fill")
                    .bold()

                TextField("Your Google API Key", text: $appStateViewModel.apiKey)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(6)

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
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(6)

            Divider()

            VStack(alignment: .leading) {
                HStack {
                    Label("Logs", systemImage: "newspaper.fill")
                        .bold()
                        .padding(.top, 5)

                    Spacer()

                    Label("Copy", systemImage: "clipboard.fill")
                        .labelStyle(.iconOnly)
                        .padding(8)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                        .onTapGesture {
                            youtubePreferenceViewModel.copyLogsToClipboard(redacted: true, appState: appStateViewModel)
                        }
                        .contextMenu {
                            Button {
                                youtubePreferenceViewModel.copyLogsToClipboard(redacted: false, appState: appStateViewModel)
                            } label: {
                                Label("Copy Raw", systemImage: "key.radiowaves.forward.fill")
                            }
                        }
                }

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(appStateViewModel.logs, id: \.self) { log in
                            LogText(text: log, color: .gray)
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(6)
        }
    }
}

struct PreferenceAPIView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubePreferenceView()
            .environmentObject(AppStateViewModel())
    }
}
