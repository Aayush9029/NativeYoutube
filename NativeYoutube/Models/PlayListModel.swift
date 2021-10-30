//
//  PlayListModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Foundation

struct PlayListModel{
    var title: String
    var thumbnail: URL
    var publishedAt: String
    var url: URL
    var channelTitle: String
    
    static let exampleData = PlayListModel(
        title: "Olivia Rodrigo - good 4 u (Official Video)",
        thumbnail: URL(string: "https://i.ytimg.com/vi/gNi_6U5Pm_o/mqdefault.jpg")!,
        publishedAt: "Yesterday",
        url: URL(string: "https://www.youtube.com/watch?v=gNi_6U5Pm_o")!,
        channelTitle: "OliviaRodrigoVEVO"
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

