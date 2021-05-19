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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ytData)
                .environmentObject(ytSearch)

                .frame(width: 900, height: 720)
            
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
    
    
}
