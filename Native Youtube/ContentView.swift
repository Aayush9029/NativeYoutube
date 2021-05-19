//
//  ContentView.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-14.
//

import SwiftUI
import Foundation
import Cocoa
import AppKit

struct ContentView: View {
    @EnvironmentObject var data: YTData
    @EnvironmentObject var search_data: YTSearch
    @State var searchVal = ""
    @State var showing_playlist_id: Bool = true
    @State var message = "Hello, World!"
    @State var isRunning = false
    var body: some View {
        
        NavigationView {
            VStack{
                ScrollView(.vertical, showsIndicators: false){
                    
                    ForEach(data.videos, id:\.self.title) { vid in
                        VideoRow(video: vid)
                            .contextMenu(ContextMenu(menuItems: {
                                VStack{
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
                                    Button(action: {
                                            let shellProcess = Process();
                                            shellProcess.launchPath = "/bin/bash";
                                            shellProcess.arguments = [
                                                "-l",
                                                "-c",
                                                // Important: this must all be one parameter to make it work.
                                                "mpv \(vid.url)",
                                            ];
                                            shellProcess.launch();                                }, label: {
                                                Text("Play Video")
                                            })
                                }
                            }))
                            .padding(.vertical, 5)
                        
                    }
                    ChangeIdView()
                        .padding()
                        .accentColor(.pink)
                        .environmentObject(data)
                }
            }
            VStack {
                ScrollView(.vertical, showsIndicators: false){
                    HStack{
                        TextField("Search..", text: $searchVal)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .cornerRadius(10)
                        
                        
                        Button(action: {
                            search_data.load(query: searchVal)
                            
                        }, label: {
                            Image(systemName: "magnifyingglass.circle")
                                .foregroundColor(.white)
                        })
                        .background(Color.blue.opacity(0.75).ignoresSafeArea(edges: .all))
                        .cornerRadius(8)
                        .shadow(color: .blue.opacity(0.5), radius: 5)
                        .padding(5)
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
        }.onAppear(perform: {
                        data.load()
        })
        
    }
}


extension ContentView{
    
    
    @discardableResult
    func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    
}
