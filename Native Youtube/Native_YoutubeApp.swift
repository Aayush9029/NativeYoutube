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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ytData)
                .frame(width: 350, height: 720)
            
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
    
    
}
