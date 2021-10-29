//
//  SearchModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Foundation
 
struct SearchModel{
    var title: String
    var thumbnail: URL
    var publishedAt: String
    var url: URL
    
    static let exampleData = SearchModel(
        title: "Olivia Rodrigo - good 4 u (Official Video)",
        thumbnail: URL(string: "https://i.ytimg.com/vi/gNi_6U5Pm_o/mqdefault.jpg")!,
        publishedAt: "2021-05-14T18:14:52Z",
        url: URL(string: "https://www.youtube.com/watch?v=gNi_6U5Pm_o")!
    )
    
    var cleanTitle: String{
        var tt =  String(title.split(separator: "(")[0])
        
        if tt.split(separator: "-").count > 1{
            tt = String(tt.split(separator: "-")[1])
        }
        if tt.split(separator: ":").count > 1{
            tt = String(tt.split(separator: ":")[1])
        }
        return tt
        
    }
}
