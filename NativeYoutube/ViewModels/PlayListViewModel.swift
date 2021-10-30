//
//  YTDataViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import SwiftyJSON

class PlayListViewModel: ObservableObject{
    
    @Published var videos = [PlayListModel]()
    @Published var currentStatus: RequestStatus = .none
    
    @AppStorage(AppStorageStrings.mpvPath.rawValue) var mpvPath = ""
    @AppStorage(AppStorageStrings.youtubeDLPath.rawValue) var youtubedlPath = ""
    @AppStorage(AppStorageStrings.apiKey.rawValue) var apiKey = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    @AppStorage(AppStorageStrings.playListID.rawValue) var playListID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
    
    let maxResults = "25"
    
    enum RequestStatus: String, Error {
        case none = "Nothing has happend yet...do something"
        case startedFetching = "Fetching playlist data"
        case doneFetching = "Fetch was successful"
        
        case invalidURL = "The Playlist URL is invalid"
        case invalidResponse = "The response we got from server is invalid"
        case unknownError = "I've never seen an error like this before"
    }
    
    
    func startFetch(){
        Task{
            do{
                DispatchQueue.main.sync {
                    self.currentStatus = .startedFetching
                }
                try await self.fetchPlayListVideos()
                
            }
            catch{
                print("Couldn't load playlist videos")
            }
        }
    }
    
    func fetchPlayListVideos() async throws{
        DispatchQueue.main.sync {
            self.videos = []
        }
        guard let url =  URL(string: "https://youtube.googleapis.com/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=\(playListID)&key=\(apiKey)&maxResults=\(maxResults)") else {
            DispatchQueue.main.sync {
                self.currentStatus = .invalidURL
            }
            throw RequestStatus.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    DispatchQueue.main.sync {
                        self.currentStatus = .invalidResponse
                    }
                    throw RequestStatus.invalidResponse
                }
                if let json = try? JSON(data: data){
                    for video in json["items"]{
                        DispatchQueue.main.sync {
                            let data = video.1
                            let title = data["snippet"]["title"].string!
                            let thumbnail_url = data["snippet"]["thumbnails"]["medium"]["url"].url!
                            var publishedAt = data["snippet"]["publishedAt"].string!
                            let url = "\(Constants.templateYoutubeURL)\(data["contentDetails"]["videoId"].string ?? "gNi_6U5Pm_o")"
                            let channelTitle = data["snippet"]["videoOwnerChannelTitle"].string!
                            publishedAt = timestampToDate(timestamp: publishedAt)
                            self.videos.append(PlayListModel(title: title, thumbnail: thumbnail_url, publishedAt: publishedAt, url: URL(string: url)!, channelTitle: channelTitle))
                            self.currentStatus = .doneFetching
                        }
                    }
                }
        }
        catch{
            DispatchQueue.main.sync {
                self.currentStatus = .unknownError
            }
            print(error.localizedDescription)
        }
    }
    
}

