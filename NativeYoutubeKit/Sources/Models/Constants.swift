import Foundation

public enum Constants {
    public static let defaultAPIKey: String = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    public static let demoYoutubeVideo: String = "https://www.youtube.com/watch?v=WrFPERZb7uw"
    public static let templateYoutubeURL: String = "https://www.youtube.com/watch?v="
    public static let defaultPlaylistID: String = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
}

public enum AppStorageStrings {
    public static let apiKey = "Api Key"
    public static let playListID = "Playlist ID for your goto playlist"
    public static let videoClickBehaviour = "com.aayush.nativeyoutube.videoClickBehaviour"
    public static let useIINA = "com.aayush.nativeyoutube.useIINA"
}

public enum VideoClickBehaviour: String, CaseIterable {
    case nothing = "Do Nothing"
    case playVideo = "Play Video"
    case openOnYoutube = "Open on Youtube"
    case playInIINA = "Play Using IINA"
}