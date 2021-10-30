//
//  SettingsViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI


class SettingsViewModel: ObservableObject{

//    Global settings
    @AppStorage(AppStorageStrings.apiKey.rawValue) var apiKey = "AIzaSyD3NN6IhiVng4iQcNHfZEQy-dlAVqTjq6Q"
    @AppStorage(AppStorageStrings.mpvPath.rawValue) var mpvPath = ""
    @AppStorage(AppStorageStrings.youtubeDLPath.rawValue) var youtubedlPath = ""
    @AppStorage(AppStorageStrings.isShowingDetails.rawValue) var isShowingDetails = false
    @AppStorage(AppStorageStrings.playListID.rawValue) var playListID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"

    @Published var showingSettings: Bool = false
    
//    SettingsView specific
    @Published var showingLogs: Bool = false
    
//    This is passed among views, it's not logs it's OUR logs.
    @Published var logs: [String] = [String]()
    
//    This is used to toggle between views
    @Published var currentPage: Pages = .playlists
    
    func changeYoutubeDLpath(newPath: String) -> Bool{
        if isValidPath(for: newPath){
            youtubedlPath = newPath
        }
        return isValidPath(for: newPath)
    }
    
    
    func changeMPVpath(newPath: String) -> Bool{
        if isValidPath(for: newPath){
            mpvPath = newPath
        }
        return isValidPath(for: newPath)
    }
    
    
    func changePlayListID(for playlistURL: String) -> Bool{
//        Using regex would be 100% better (this is a quick and dirty method)
        var changed = false
        let splitted = playlistURL.split(separator: "&")
        for splitted in splitted {
            if splitted.contains("list"){
                let id = splitted.split(separator: "=")
                if let idCount = id.last?.count{
                    if idCount > 6{
                        self.playListID = String(id.last!)
                        changed = true
                    }
                }
            }
        }
        return changed
    }
    
    func copyLogsToClipboard(redacted: Bool = true){
        var logsText = ""
        for log in logs {
            logsText += log
            logsText += "\n"
        }
        if redacted {
            logsText = logsText.replacingOccurrences(of: apiKey, with: "********APIKEY*****")
        }else{
            logsText += "\n API KEY: \"\(apiKey)\"\n youtubedlPath: \"\(youtubedlPath)\"\n mpvPath: \"\(mpvPath)\""
        }
        
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(logsText, forType: .string)

    }

    
    func addToLogs(for page: Pages, message: String){
        self.logs.append("Log at: \(Date()), from \(page.rawValue), message => \(message)")
    }
    
    
    func isValidPath(for path: String) -> Bool{
        //        need to change to a better path checking function (template for now)
        return path.contains("/")
    }
    
    func play(for url: URL, audioOnly:Bool = false){
        print("killing process")
        stopPlaying()
        print("kil done")
        print("Playing")
        
        let shellProcess = Process();
                          shellProcess.launchPath = "/bin/bash";
                          shellProcess.arguments = [
                              "-l",
                              "-c",
                              // Important: this must all be one parameter to make it work.
                              "\(mpvPath) \(url) --script-opts=ytdl_hook-ytdl_path=\(youtubedlPath) \(audioOnly ? "--no-video" : "")",
                          ];
                          shellProcess.launch();
    }
    
    func stopPlaying(){
        let shell_out = shell("mpv", "/usr/bin/killall")
        self.logs.append(shell_out)
    }
    func shell(_ command: String, _ using: String) -> String {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
}
