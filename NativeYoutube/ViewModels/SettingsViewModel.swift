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
    @AppStorage(AppStorageStrings.isShowingDetails.rawValue) var isShowingDetails = false
    @AppStorage(AppStorageStrings.playListID.rawValue) var playListID = "PLFgquLnL59alKyN8i_z5Ofm_h0KthT072"
    
    @Published var showingSettings: Bool = false
    
    //    SettingsView specific
    @Published var showingLogs: Bool = false
    
    //    This is passed among views, it's not logs it's OUR logs.
    @Published var logs: [String] = [String]()
    
    //    This is used to toggle between views
    @Published var currentPage: Pages = .playlists
    
    @Published var isPlaying: Bool = false
    
    @Published var currentlyPlaying: String = ""
    
    
    var shellProcess: Process?

    
    
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
            logsText += "\n API KEY: \"\(apiKey)\""
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
    
    func stopPlaying(){
        currentlyPlaying = ""
        isPlaying = false
        self.logs.append(shell("killall IINA"))
    }
    
    func togglePlaying(_ title: String){
        stopPlaying()
        isPlaying.toggle()
        currentlyPlaying = title
    }
    
    func playAudioYTDL(url: URL, title: String){
        togglePlaying(title)
        guard let ytdlPath = Bundle.main.url(forResource: "youtube-dl", withExtension: "") else{
            print("YTDL not in bundle, provide custom")
            fatalError("YTDL not in bundle, provide custom")
        }
        let betterPath = ytdlPath.absoluteString.replacingOccurrences(of: "file:///", with: "/")
        let output = shell("python3 \(betterPath) '\(url)' -g")
        let splitted = output.split(separator: "\n")
        
        if let audioUrl = splitted.last{
            DispatchQueue.main.async {
                self.logs.append(self.shell("open -a iina '\(audioUrl)'"))
            }
        }
    }

    func shell(_ command: String) -> String {
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
