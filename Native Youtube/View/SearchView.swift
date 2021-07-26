//
//  SearchView.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var search_data: YTSearch
    @State var searchVal = ""
    
    @AppStorage("apiKey") var apiKey = ""
    @AppStorage("mpv_path") var mpvPath = ""
    @AppStorage("streamlink_path") var youtubedlPath = ""
    
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false){
                HStack{
                    TextField("Search..", text: $searchVal)
                        .textFieldStyle(PlainTextFieldStyle())
                        .underlineTextField(color: .blue)
                    
                    CustomButton(image: "magnifyingglass", color: .blue)
                        .frame(width: 69)
                        .onTapGesture {
                        search_data.load(query: searchVal)
                    }
                } .padding()
                
                
                ForEach(search_data.search_videos, id:\.self.title) { vid in
                    SearchDisplay(video: vid)
                        .padding(.horizontal)
                        .contextMenu(ContextMenu(menuItems: {
                            VStack{
                                Button(action: {
                                    print("----")
                                    print(apiKey)
                                    print(mpvPath)
                                    print("----")
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
                    
                    
                }
                Spacer()
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigation){
                HStack{
                    
                    Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left") })
                    
                }
            }
        }
    }
}


extension SearchView{
    func toggleSidebar() {
        DispatchQueue.main.async {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }
    }
}
