//
//  ContentView.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-14.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: YTData
    @EnvironmentObject var search_data: YTSearch
    
    var body: some View {
        
        NavigationView {
            
            PlayListView()
                .frame(minWidth: 320, idealWidth: 400)
                .environmentObject(data)
            
            ZStack{
                EffectsView()
                SearchView()
                    .frame(minWidth: 450, idealWidth: 500)

                    .environmentObject(search_data)
            }
            
        }.onAppear(perform: {
            data.load()
        })
        
    }
}


