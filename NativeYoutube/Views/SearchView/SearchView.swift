//
//  SearchView.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false){
                HStack{
                    TextField("Search..", text: $searchViewModel.searchQuery)
                        .textFieldStyle(PlainTextFieldStyle())
                    Button("Search"){
                        searchViewModel.startSearch()
                        settingsViewModel.addToLogs(for: .search, message:"Searching for \($searchViewModel.searchQuery)")
                    }
                    
                } .padding()
                
                SearchedVideosView()
                    .environmentObject(searchViewModel)
                    .environmentObject(settingsViewModel)
                
                Spacer()
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



