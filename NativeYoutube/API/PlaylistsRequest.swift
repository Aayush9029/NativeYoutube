//
//  PlaylistsRequest.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import Foundation
import SwiftyJSON

struct PlaylistsRequest: Request {
    let apiKey: String
    let playListID: String
    let maxResults: String

    func createURL() -> URL? {
        let url = "https://youtube.googleapis.com"
        let path = "/youtube/v3/playlistItems?part=snippet%2CcontentDetails%2Cstatus&playlistId=\(playListID)&key=\(apiKey)&maxResults=\(maxResults)"
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
