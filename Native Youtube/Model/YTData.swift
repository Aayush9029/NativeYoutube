//
//  YTData.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-14.
//


import Foundation
import SwiftyJSON
import SwiftUI
import Alamofire

//https://www.googleapis.com/youtube/v3/videos?KEY=AIzaSyCnOLgdnqvCSBYHjd_HxR-6l-pH4mY5TrU

//Playlist
//https://www.youtube.com/playlist?list=PLFgquLnL59alKyN8i_z5Ofm_h0KthT072


//
struct Video{
    var title: String
    var thumbnail: URL
    var publishedAt: String
    var url: URL
    var channelTitle: String
    
    static let exampleData = Video(
        title: "Olivia Rodrigo - good 4 u (Official Video)",
        thumbnail: URL(string: "https://i.ytimg.com/vi/gNi_6U5Pm_o/mqdefault.jpg")!,
        publishedAt: "2021-05-14T18:14:52Z",
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

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class YTData: ObservableObject{
    
    @Published var videos = [Video]()
    @AppStorage("playlistID") var savedID: String = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
    
    var playlistID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
    let apiKey = "AIzaSyCnOLgdnqvCSBYHjd_HxR-6l-pH4mY5TrU"
    let maxResults = "25"
    
    init() {
        self.playlistID = savedID
    }
    
    
    func changeDefaultPlaylist(newPlaylistID: String){
        savedID = newPlaylistID
        self.playlistID = newPlaylistID
        self.load()
    }
    
    
    func revertToDefault(){
        savedID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
        self.playlistID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
        self.load()
    }
    
    func load(){
        videos = []
        let url =  URL(string: "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=\(playlistID)&key=\(apiKey)&maxResults=\(maxResults)")
        
        let request = AF.request(url!)
        request.responseJSON{ data in
            if let json = try? JSON(data: data.data!){
                
                for video in json["items"]{
                    let data = video.1
                    
                    let title = data["snippet"]["title"].string
                    let thumbnail_url = data["snippet"]["thumbnails"]["medium"]["url"].url
                    let publishedAt = data["snippet"]["publishedAt"].string
                    let url = "https://www.youtube.com/watch?v=\(data["contentDetails"]["videoId"].string ?? "gNi_6U5Pm_o")"
                    let channelTitle = data["snippet"]["videoOwnerChannelTitle"].string
                    
                    self.videos.append(Video(title: title! , thumbnail: thumbnail_url!, publishedAt: publishedAt!, url: URL(string: url)!, channelTitle: channelTitle!))
                }
                
            }
        }
        
    }
}
