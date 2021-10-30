//
//  Constant.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Foundation


struct Constants {
    let apiKey: String = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    let mpvPath: String = ""
    let youtubeDLPath: String = ""
    static let demoYoutubeVideo: String = "https://www.youtube.com/watch?v=WrFPERZb7uw"
    static let templateYoutubeURL: String = "https://www.youtube.com/watch?v="
}


enum StatusStates: String {
    case starting = "Starting.."
    case badOuath = "Incorrect Access Token"
    case badClient = "Incorrect Client ID"
    case badScopes = "BAD Scopes (Client ID / Access Token)"
    case userValidating = "Validating User"
    case userValidated = "User Validated"
    case userLoading = "Loading User Data"
    case userLoaded = "Got User Data"
    case videoLoading = "Loading videos"
    case videoLoaded = "View Has Been Loaded"
}

enum AppStorageStrings: String{
    case apiKey = "Api Key"
    case mpvPath = "Mpv Path"
    case youtubeDLPath = "Youtube DL Path"
    case isShowingDetails = "Show Detailed Info"
    case playListID = "Playlist ID for your goto playlist"
}
