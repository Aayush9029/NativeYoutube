//
//  SettingsView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
            VStack{
                VStack {
                    HStack{
                        VStack(alignment: .leading){
                            Text("Native Youtube Settings")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .lineLimit(1)
                        }
                        Spacer()
                    }.padding(.vertical)
                    VStack(alignment: .leading, spacing: 10){
                        TextField("Your Google API Key", text: $settingsViewModel.apiKey)
                        Link(
                            destination: URL(string: Constants.demoYoutubeVideo)!,
                            label: {
                                HStack{
                                    Spacer()
                                    Label("How to get Google API Key?", systemImage: "globe")
                                    Spacer()
                                }
                                .padding(8)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                            }
                        )
                        
                        Divider()
                        
                        TextField("MPV path", text: $settingsViewModel.mpvPath)
                        
                        Text("Open Terminal > \(Text("which mpv").font(.callout).bold())")
                        
                            .foregroundColor(.gray)
                            .font(.caption)
                        Divider()
                        TextField("YoutubeDL Path", text: $settingsViewModel.youtubedlPath)
                        
                        Text("Open Terminal > \(Text("which youtube-dl").font(.callout).bold())")
                        
                            .foregroundColor(.gray)
                            .font(.caption)
                        
                    }.padding([.bottom])
                        .textFieldStyle(.roundedBorder)
                    
                }
                
                Divider()
                VStack(alignment: .leading){
                    HStack{
                        Text("Logs")
                            .font(.title3.bold())
                            .padding(.top, 5)
                        Spacer()
                        
                        Label("Copy Logs", systemImage: "paperclip")
                            .padding(8)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .onTapGesture {
                                settingsViewModel.copyLogsToClipboard(redacted: true)
                            }
                            .contextMenu {
                                Button("Copy raw"){
                                    settingsViewModel.copyLogsToClipboard(redacted: false)
                                }
                            }
                        
                        Label( settingsViewModel.showingLogs ? "Hide" : "Show", systemImage:  settingsViewModel.showingLogs ? "chevron.up" : "chevron.down")
                            .padding(8)
                            .background(.thinMaterial)
                            .cornerRadius(20)
                            .onTapGesture {                                    settingsViewModel.showingLogs.toggle()

                            }
                    }
                    Spacer()
                    Group{
                        Divider()
                        if settingsViewModel.showingLogs{
                            ScrollView(.vertical, showsIndicators: false){
                                VStack(alignment: .leading){
                                    ForEach(settingsViewModel.logs, id: \.self){log in
                                        LogText(text: log, color: .gray)
                                            .id(UUID())
                                    }
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                }
            }
            .onAppear(perform: {
                settingsViewModel.showingSettings = true
            })
            .onDisappear(perform: {
                settingsViewModel.showingSettings = false
            })
        .padding(.horizontal)
        .frame(width: 350, height: settingsViewModel.showingLogs ? 540 : 340)

    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SettingsViewModel())
    }
}

