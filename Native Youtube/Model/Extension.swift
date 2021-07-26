//
//  Extension.swift
//  Extension
//
//  Created by Aayush Pokharel on 2021-07-25.
//

import Foundation
import SwiftUI
import SwiftyJSON


class AuthExtractor{
    
    @AppStorage("apiKey") var apiKey = ""
    @AppStorage("mpv_path") var mpvPath = ""
    @AppStorage("streamlink_path") var youtubedlPath = ""

    @AppStorage("config_installed") var configuredEh = false

    struct config_model: Decodable{
        let AuthToken: String
        let MpvPath: String
        let YoutubedlPath: String

    }
    
    init(){
        read_config_file()
    }
    
    
    func read_config_file(){
        
        //  Function to extract the auth token from the config file from home directory.
        let config_file = Bundle.path(forResource: "config", ofType: "json", inDirectory: NSHomeDirectory()+"/.mubbi")
        if let path = config_file {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let config_data = try! JSONDecoder().decode(config_model.self, from: data)
                
                apiKey = config_data.AuthToken
                mpvPath = config_data.MpvPath
                youtubedlPath = config_data.YoutubedlPath
                configuredEh = true
            } catch let error {
                print("parse error: \(error.localizedDescription)")
                configuredEh = false
            }
        }else{
//             MARK: HANDLE ERROR HERE
            print("Config not found error...")
            
        }
    }
    
}
