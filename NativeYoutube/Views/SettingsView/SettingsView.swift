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
                        destination: URL(string: "https://www.youtube.com/watch?v=WrFPERZb7uw")!,
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
                    TextField("MPV path", text: $settingsViewModel.mpvPath)
                    
                    Text("Open Terminal > \(Text("which mpv").font(.title3).bold())")
                    
                        .foregroundColor(.gray)
                        .font(.caption)
                    Divider()
                    TextField("YoutubeDL Path", text: $settingsViewModel.youtubedlPath)
                    
                    Text("Open Terminal > \(Text("which youtube-dl").font(.title3).bold())")
                    
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
                    
                    Label("Copy", systemImage:  "paperclip")
                        .onTapGesture {
                            //                            settingsViewModel.copyLogsToClipboard()
                        }
                        .contextMenu {
                            Button("Copy Raw"){
                                //                                    settingsViewModel.copyLogsToClipboard(redacted: false)
                            }
                            Button("Copy Redacted"){
                                //                                settingsViewModel.copyLogsToClipboard(redacted: true)
                            }
                        }
                    
                    Label( settingsViewModel.showingLogs ? "Hide" : "Show", systemImage:  settingsViewModel.showingLogs ? "chevron.up" : "chevron.down")
                        .onTapGesture {
                            settingsViewModel.showingLogs.toggle()
                        }
                }
                Spacer()
                Group{
                    if settingsViewModel.showingLogs{
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(alignment: .leading){
                                
                                ForEach(settingsViewModel.logs, id: \.self){log in
                                    LogText(text: log, color: .gray)
                                        .id(UUID())
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 350)
        .padding(.horizontal)
    }
}
