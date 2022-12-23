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

    @AppStorage(AppStorageStrings.apiKey) var apiKey = Constants.defaultAPIKey
    @AppStorage(AppStorageStrings.playListID) var playListID = Constants.defaultPlaylistID
    @AppStorage(AppStorageStrings.useIINA) var useIINA: Bool = false
    @AppStorage(AppStorageStrings.videoClickBehaviour) var vidClickBehaviour: VideoClickBehaviour = .playVideo

    // MARK: States

    @Published var logs: [String] = .init()
    @Published var isPlaying: Bool = false
    @Published var currentlyPlaying: String = ""

    func addToLogs(for page: Pages, message: String) {
        logs.append("Log at: \(Date()), from \(page.rawValue), message => \(message)")
    }

    func stopPlaying() {
        currentlyPlaying = ""
        isPlaying = false
        if useIINA {
            Task {
                let shellOutput = shell("killall IINA")
                DispatchQueue.main.async {
                    self.logs.append(shellOutput)
                }
            }
        }
    }

    func togglePlaying(_ title: String) {
        stopPlaying()
        isPlaying.toggle()
        currentlyPlaying = title
    }

    func playVideoIINA(url: URL, title: String) {
        togglePlaying(title)
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
