//
//  ContentView.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: YTData
    @State var showing_playlist_id: Bool = true
    var body: some View {
        
        VStack{
            ScrollView(.vertical, showsIndicators: false){
                
                ForEach(data.videos, id:\.self.title) { vid in
                    VideoRow(video: vid)
                        .contextMenu(ContextMenu(menuItems: {
                                                Button(action: {
                                                    print("MAKE THIS WORK")
                                                }, label: {
                                                    Text("Play")
                                                })
                                            }))
                        .padding(.vertical, 5)
                    
                }
                        ChangeIdView()
                            .padding()
                            .accentColor(.pink)
                            .environmentObject(data)
                    }
        }.onAppear(perform: {
            data.load()
        })
        
    }
}
