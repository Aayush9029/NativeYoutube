//
//  YTSearchModel.swift
//  Native Youtube
//
//  Created by Aayush Pokharel on 2021-05-18.
//

import Foundation
import SwiftyJSON
import SwiftUI
import Alamofire
 
struct SearchVideo{
    var title: String
    var thumbnail: URL
    var publishedAt: String
    var url: URL
    
    static let exampleData = SearchVideo(
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


class YTSearch: ObservableObject{
    
    @Published var search_videos = [SearchVideo]()
    @AppStorage("apiKey") var apiKey = ""

    let maxResults = "25"
  
    func load(query: String){
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        search_videos = []
        
        let url =  URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(apiKey)&maxResults=\(maxResults)")
        
        let request = AF.request(url!)
        request.responseJSON{ data in
            if let json = try? JSON(data: data.data!){
                
                for video in json["items"]{
                    let data = video.1
//                    self.videoIDs.append(data["id"]["videoId"].string!)
                    if let vidID = data["id"]["videoId"].string{
                    self.loadData(videoID: vidID)
                    }
                }
                
            }
        }
        
    }
    
    func dateToString(date: Date) -> String{
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date){
            return "Today"
            
        }else if calendar.isDateInYesterday(date){
            return "Yesterday"
            
        }else{
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
    }

    
    func timestampToDate(timestamp: String) -> String{
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let d = dateStringFormatter.date(from: timestamp)
        
        if let d = d {
           return dateToString(date: d)
        }
        
        return timestamp
    }
    
    func loadData(videoID: String){
        let url = URL(string: "https://youtube.googleapis.com/youtube/v3/videos?part=snippet&id=\(videoID)&key=\(apiKey)&maxResults=\(maxResults)")
        
        let request = AF.request(url!)
        request.responseJSON{ data in
            if let json = try? JSON(data: data.data!){
                for video in json["items"]{
                    let data = video.1
                    let title = data["snippet"]["title"].string
                    let thumbnail_url = data["snippet"]["thumbnails"]["medium"]["url"].url
                    var publishedAt = data["snippet"]["publishedAt"].string
                    let url = "https://www.youtube.com/watch?v=\(videoID)"
                    
                    publishedAt = self.timestampToDate(timestamp: publishedAt!)
                    
                    self.search_videos.append(SearchVideo(title: title!, thumbnail: thumbnail_url!, publishedAt: publishedAt!, url: URL(string: url)!))
                    
                }
                
            }
        }
    } 
}
