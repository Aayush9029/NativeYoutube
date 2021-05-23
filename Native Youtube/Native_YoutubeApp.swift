//
//  Native_YoutubeApp.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-14.
//

import SwiftUI

@main
struct Native_YoutubeApp: App {
    @StateObject var ytData = YTData()
    @StateObject var ytSearch = YTSearch()
    @AppStorage("firstlaunch") var firstTime = true


    var body: some Scene {
        WindowGroup{
            if !firstTime{
            ContentView()
                .environmentObject(ytData)
                .environmentObject(ytSearch)
            }else{
                WelcomeView()
                    .frame(width: 900, height: 720)

            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
    
    
}
