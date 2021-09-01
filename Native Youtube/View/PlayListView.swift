//
//  PlayListSidebarMain.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-23.
//

import SwiftUI


struct PlayListView: View {
    @EnvironmentObject var data: YTData
    @State var showing_playlist_id: Bool = true
    
    @AppStorage("apiKey") var apiKey = ""
    @AppStorage("mpv_path") var mpvPath = ""
    @AppStorage("streamlink_path") var youtubedlPath = ""

    
    
    @State var apiInput = ""
    
    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                
                ForEach(data.videos, id:\.self.title) { vid in
                    VideoRow(video: vid)
                        .contextMenu(ContextMenu(menuItems: {
                            VStack{
                                Button(action: {
                                    print("----")
                                    print(apiKey)
                                    print(mpvPath)
                                    print("----")
                                    stopPlaying()
                                    let shellProcess = Process();
                                                      shellProcess.launchPath = "/bin/bash";
                                                      shellProcess.arguments = [
                                                          "-l",
                                                          "-c",
                                                          // Important: this must all be one parameter to make it work.
                                                          "\(mpvPath) \(vid.url) --script-opts=ytdl_hook-ytdl_path=\(youtubedlPath) --no-video",
                                                      ];
                                                      shellProcess.launch();
                                }, label: {
                                    Text("Play Audio")
                                })
                                Button(action: {
                                    print("----")
                                    print(apiKey)
                                    print(mpvPath)
                                    print("----")
                                    stopPlaying()
                                    let shellProcess = Process();
                                                      shellProcess.launchPath = "/bin/bash";
                                                      shellProcess.arguments = [
                                                          "-l",
                                                          "-c",
                                                          // Important: this must all be one parameter to make it work.
                                                          "\(mpvPath) \(vid.url) --script-opts=ytdl_hook-ytdl_path=\(youtubedlPath)",
                                                      ];
                                                      shellProcess.launch();
                                }, label: {
                                    Text("Play Video")
                                })
                            }
                        }))
                        .padding(.vertical, 5)
                    
                }
                ChangeIdView()
                    .environmentObject(data)
                .padding(.horizontal)
            }
        }
    }
}
