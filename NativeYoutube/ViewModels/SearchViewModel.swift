//
//  YTSearchViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI
import SwiftyJSON

class SearchViewModel: ObservableObject{
    @Published var searchQuery: String = ""
    
    @Published var videos = [SearchModel]()
    @Published var currentStatus: RequestStatus = .none
    
    @AppStorage(AppStorageStrings.mpvPath.rawValue) var mpvPath = ""
    @AppStorage(AppStorageStrings.youtubeDLPath.rawValue) var youtubedlPath = ""
    @AppStorage(AppStorageStrings.apiKey.rawValue) var apiKey = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    
    let maxResults = "25"
    
    enum RequestStatus: String, Error {
        case none = "Nothing has happend yet...search something"
        case startedFetching = "Fetching video data"
        case doneFetching = "Fetch was successful"
        
        case invalidURL = "The api URL is invalid"
        case invalidResponse = "The response we got from server is invalid"
        
        case videoIDError = "Error fetching video IDs"
        case videoDetailsError = "Error fetching video details"
        
        case unknownError = "I've never seen an error like this before"
    }
    
    func startSearch(){
        Task{
            do{
                try await self.getVideoIDs()
            }
            catch{
                DispatchQueue.main.sync {
                    self.currentStatus = .videoIDError
                }
            }
        }
    }
    
    func getVideoIDs() async throws{
        let query = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        DispatchQueue.main.sync {
            self.videos = []
        }
        
        guard let url =  URL(string: "https://youtube.googleapis.com/youtube/v3/search?q=\(query)&key=\(apiKey)&maxResults=\(maxResults)") else{
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
                    let data = video.1
                    //                    self.videoIDs.append(data["id"]["videoId"].string!)
                    if let videoID = data["id"]["videoId"].string{
                        do{
                            try await self.fetchVideoDetails(for: videoID)
                        }
                        catch{
                            DispatchQueue.main.sync {
                                self.currentStatus = .videoDetailsError
                            }
                        }
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
    
    func fetchVideoDetails(for videoID: String) async throws {
        guard let url = URL(string: "https://youtube.googleapis.com/youtube/v3/videos?part=snippet&id=\(videoID)&key=\(apiKey)&maxResults=\(maxResults)") else{
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
                        let url = "https://www.youtube.com/watch?v=\(videoID)"
                        
                        publishedAt = timestampToDate(timestamp: publishedAt)
                        
                        self.videos.append(SearchModel(title: title, thumbnail: thumbnail_url, publishedAt: publishedAt, url: URL(string: url)!))
                    }
                }
                
            }
        }
        catch{
            DispatchQueue.main.sync {
                self.currentStatus = .unknownError
            }
            print(error.localizedDescription)
            fatalError("Handle this error")
        }
        
    }
    
}

