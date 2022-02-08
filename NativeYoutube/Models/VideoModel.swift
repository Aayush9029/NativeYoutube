//
//  VideoModal.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import Foundation
import SwiftyJSON

struct VideoModel {
    var id: String
    var title: String
    var thumbnail: URL
    var publishedAt: String
    var url: URL
    var channelTitle: String

    static let exampleData = VideoModel(
        id: "0",
        title: "Olivia Rodrigo - good 4 u (Official Video)",
        thumbnail: URL(string: "https://i.ytimg.com/vi/gNi_6U5Pm_o/mqdefault.jpg")!,
        publishedAt: "Yesterday",
        url: URL(string: "https://www.youtube.com/watch?v=gNi_6U5Pm_o")!,
        channelTitle: "OliviaRodrigoVEVO"
    )

    var cleanTitle: String {
        var tt =  String(title.split(separator: "(")[0])

        if tt.split(separator: "-").count > 1 {
            tt = String(tt.split(separator: "-")[1])
        }
        if tt.split(separator: ":").count > 1 {
            tt = String(tt.split(separator: ":")[1])
        }
        return tt
    }

    enum VideoKind: String {
        case playlist = "youtube#playlistItem"
        case search = "youtube#searchResult"
    }
}

extension VideoModel {
    static func parseJSON(json: JSON) -> VideoModel? {
        if let kind = VideoKind(rawValue: json["kind"].stringValue) {
            var id: String
            var url: URL
            var channelTitle: String

            let snippet = json["snippet"]

            if kind == .playlist {
                id = json["id"].stringValue
                url = URL(string: "\(Constants.templateYoutubeURL)\(json["contentDetails"]["videoId"].string ?? "gNi_6U5Pm_o")")!
                channelTitle = snippet["videoOwnerChannelTitle"].string ?? "Unknown"
            } else {
                id = json["id"]["videoId"].string ?? "gNi_6U5Pm_o"
                url = URL(string: "\(Constants.templateYoutubeURL)\(id)")!
                channelTitle = snippet["channelTitle"].string ?? "Unknown"
            }

            let title = snippet["title"].stringValue
            let thumbnailURL = snippet["thumbnails"]["medium"]["url"].url ?? URL(string: "https://via.placeholder.com/140x100")!
            let publishedAt = timestampToDate(timestamp: snippet["publishedAt"].stringValue)

            return VideoModel(id: id,
                              title: title,
                              thumbnail: thumbnailURL,
                              publishedAt: publishedAt,
                              url: url,
                              channelTitle: channelTitle
            )
        }

        return nil
    }
}
