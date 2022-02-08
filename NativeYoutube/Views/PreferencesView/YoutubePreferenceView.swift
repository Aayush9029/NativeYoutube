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

    @State var showLogs = false

    var body: some View {
        VStack {
            Group {
                TextField("Your Google API Key", text: $appStateViewModel.apiKey)
                    .padding([.top, .bottom], 10)
                    .textFieldStyle(.roundedBorder)

                Link(
                    destination: URL(string: Constants.demoYoutubeVideo)!,
                    label: {
                        HStack{
                            Spacer()
                            Label("How to get Google API Key?", systemImage: "globe")
                            Spacer()
                        }
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    }
                )
            }

            Divider()

            Group {
                HStack {
                    Text("Logs")
                        .font(.title3.bold())
                        .padding(.top, 5)

                    Spacer()

                    Label("Copy Logs", systemImage: "paperclip")
                        .padding(8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .onTapGesture {
                            youtubePreferenceViewModel.copyLogsToClipboard(redacted: true, appState: appStateViewModel)
                        }
                        .contextMenu {
                            Button("Copy raw"){
                                youtubePreferenceViewModel.copyLogsToClipboard(redacted: false, appState: appStateViewModel)
                            }
                        }
                    
                    Label(showLogs ? "Hide" : "Show", systemImage: showLogs ? "chevron.up" : "chevron.down")
                        .padding(8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .onTapGesture {
                            showLogs.toggle()
                        }
                }

                Divider()

                if showLogs {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(appStateViewModel.logs, id: \.self) { log in
                                LogText(text: log, color: .gray)
                            }
                        }
                    }
                    .padding(.bottom)
                    .frame(height: 120)
                }
            }
        }
        .padding(.horizontal)
        .frame(width: 350)
    }
}

struct PreferenceAPIView_Previews: PreviewProvider {
    static var previews: some View {
        YoutubePreferenceView()
            .environmentObject(AppStateViewModel())
    }
}
