//
//  WebViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-30.
//

import Foundation

class WebViewModel: ObservableObject {
    @Published var link: String
    @Published var didFinishLoading: Bool = false
    @Published var pageTitle: String
    
    init (link: String) {
        self.link = link
        self.pageTitle = ""
    }
}
