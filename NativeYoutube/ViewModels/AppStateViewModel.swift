//
//  AppStateViewModel.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import Combine
import SwiftUI

class AppStateViewModel: ObservableObject {
    // MARK: Global values

    @AppStorage(AppStorageStrings.apiKey.rawValue) var apiKey = Constants.defaultAPIKey
    @AppStorage(AppStorageStrings.playListID.rawValue) var playListID = Constants.defaultPlaylistID
    @AppStorage(AppStorageStrings.useIINA.rawValue) var useIINA: Bool = false

    // MARK: States

    @Published var logs: [String] = .init()
    @Published var isPlaying: Bool = false
    @Published var currentlyPlaying: String = ""

    func changePlayListID(for playlistURL: String) -> Bool {
        //        Using regex would be 100% better (this is a quick and dirty method)
        var changed = false
        let splitted = playlistURL.split(separator: "&")
        for splitted in splitted {
            if splitted.contains("list") {
                let id = splitted.split(separator: "=")
                if let idCount = id.last?.count {
                    if idCount > 6 {
                        playListID = String(id.last!)
                        changed = true
                    }
                }
            }
        }
        return changed
    }

    func addToLogs(for page: Pages, message: String) {
        logs.append("Log at: \(Date()), from \(page.rawValue), message => \(message)")
    }

    func stopPlaying() {
        currentlyPlaying = ""
        isPlaying = false
        Task {
            let shellOutput = shell("killall IINA")
            DispatchQueue.main.async {
                self.logs.append(shellOutput)
            }
        }
    }

    func togglePlaying(_ title: String) {
        stopPlaying()
        isPlaying.toggle()
        currentlyPlaying = title
    }

    func playVideoIINA(url: URL, title: String) {
//        togglePlaying(title)
        Task {
            DispatchQueue.main.async {
                self.logs.append(self.shell("open -a iina '\(url)'"))
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
