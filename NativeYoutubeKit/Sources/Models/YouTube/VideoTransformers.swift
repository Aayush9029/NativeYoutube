import Foundation
import Shared

// Video transformation helpers
public extension SearchItem {
    func toVideo() -> Video? {
        guard let videoId = id.videoId else { return nil }
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        let thumbnail = URL(string: snippet.thumbnails.medium?.url ?? "https://via.placeholder.com/140x100")!
        let publishedAt = DateConverter.timestampToDate(timestamp: snippet.publishedAt)
        
        return Video(
            id: videoId,
            title: snippet.title,
            thumbnail: thumbnail,
            publishedAt: publishedAt,
            url: url,
            channelTitle: snippet.channelTitle
        )
    }
}

public extension PlaylistItem {
    func toVideo() -> Video {
        let videoId = contentDetails.videoId
        let url = URL(string: "https://www.youtube.com/watch?v=\(videoId)")!
        let thumbnail = URL(string: snippet.thumbnails.medium?.url ?? "https://via.placeholder.com/140x100")!
        let publishedAt = DateConverter.timestampToDate(timestamp: snippet.publishedAt)
        let channelTitle = snippet.videoOwnerChannelTitle ?? snippet.channelTitle
        
        return Video(
            id: videoId,
            title: snippet.title,
            thumbnail: thumbnail,
            publishedAt: publishedAt,
            url: url,
            channelTitle: channelTitle
        )
    }
}