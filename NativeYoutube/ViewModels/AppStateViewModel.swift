//
//  AppStateViewModel.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    // MARK: Global values

    @AppStorage(AppStorageStrings.apiKey.rawValue) var apiKey = Constants.defaultAPIKey
    @AppStorage(AppStorageStrings.playListID.rawValue) var playListID = Constants.defaultPlaylistID

    // MARK:  States

    @Published var showingSettings: Bool = false

    // This is passed among views, it's not logs it's OUR logs.
    @Published var logs: [String] = [String]()

    @Published var isPlaying: Bool = false

    @Published var currentlyPlaying: String = ""

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
        Task {
            let shellOutput = shell("killall IINA")
            DispatchQueue.main.async {
                self.logs.append(shellOutput)
            }
        }
    }

    func togglePlaying(_ title: String){
        stopPlaying()
        isPlaying.toggle()
        currentlyPlaying = title
    }

    func playAudioYTDL(url: URL, title: String) {
        togglePlaying(title)
        Task {
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
    }

    private func shell(_ command: String) -> String {
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
