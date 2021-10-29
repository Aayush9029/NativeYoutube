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
                    }
                    
                } .padding()
                
                SearchedVideosView()
                    .environmentObject(searchViewModel)
                    .environmentObject(settingsViewModel)
                
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



