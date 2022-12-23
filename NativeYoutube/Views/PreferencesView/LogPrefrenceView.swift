//
//  LogTextView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct LogPrefrenceView: View {
    @EnvironmentObject var appStateViewModel: AppStateViewModel
    @StateObject var youtubePreferenceViewModel: YoutubePreferenceViewModel = .init()

    var body: some View {
        Group {
            DisclosureGroup {
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(appStateViewModel.logs, id: \.self) { log in
                                LogText(text: log, color: .gray)
                            }
                        }
                    }
                }
            }
        label: {
                HStack {
                    Label("Logs", systemImage: "newspaper.fill")
                        .bold()
                        .padding(.top, 5)

                    Spacer()

                    Label("Copy", systemImage: "clipboard.fill")
                        .labelStyle(.iconOnly)
                        .thinRoundedBG(padding: 8, material: .thinMaterial)
                        .clipShape(Circle())
                        .onTapGesture {
                            youtubePreferenceViewModel.copyLogsToClipboard(redacted: true, appState: appStateViewModel)
                        }
                        .contextMenu {
                            VStack {
                                Button {
                                    youtubePreferenceViewModel.copyLogsToClipboard(redacted: false, appState: appStateViewModel)
                                } label: {
                                    Label("Copy Raw", systemImage: "key.radiowaves.forward.fill")
                                }

                                Button {
                                    appStateViewModel.logs = []
                                } label: {
                                    Label("Clear Logs", systemImage: "trash.fill")
                                }
                            }
                        }
                }
            }
        }
        .thinRoundedBG()
    }
}

struct LogText: View {
    let text: String
    var color: Color = .gray

    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.gray)
    }
}

struct BoldTextView_Previews: PreviewProvider {
    static var previews: some View {
        LogText(text: "All streams are offline :(", color: .gray)
    }
}
