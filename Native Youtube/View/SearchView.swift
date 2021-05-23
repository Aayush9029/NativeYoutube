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
                                    let shellProcess = Process();
                                    shellProcess.launchPath = "/bin/bash";
                                    shellProcess.arguments = [
                                        "-l",
                                        "-c",
                                        // Important: this must all be one parameter to make it work.
                                        "mpv \(vid.url)",
                                    ];
                                    shellProcess.launch();
                                    print(vid.url)
                                }, label: {
                                    Text("Play Video")
                                })
                                
                                Button(action: {
                                    let shellProcess = Process();
                                    shellProcess.launchPath = "/bin/bash";
                                    shellProcess.arguments = [
                                        "-l",
                                        "-c",
                                        // Important: this must all be one parameter to make it work.
                                        "mpv \(vid.url) --no-video",
                                    ];
                                    shellProcess.launch();
                                }, label: {
                                    Text("Play Music")
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
