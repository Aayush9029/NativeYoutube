//
//  SearchRequest.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import Foundation
import SwiftyJSON

struct SearchRequest: Request {
    let apiKey: String
    let query: String
    let maxResults: String

    func createURL() -> URL? {
        let url = "https://youtube.googleapis.com"
        let path = "/youtube/v3/search?part=snippet&q=\(query)&key=\(apiKey)&type=video&maxResults=\(maxResults)"
        let apiString = url + path

        return URL(string: apiString)
    }

    static func parseJSON(json: JSON) -> [VideoModel] {
        var videos: [VideoModel] = []

        if let items = json["items"].array, items.count > 0 {
            for videoJSON in items {
                if let video = VideoModel.parseJSON(json: videoJSON) {
                    videos.append(video)
                }
            }
        }
        return videos
    }
}
