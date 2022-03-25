//
//  YoutubePreferenceViewModel.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import SwiftUI

class YoutubePreferenceViewModel: ObservableObject {
    
    func copyLogsToClipboard(redacted: Bool = true, appState: AppStateViewModel) {
        var logsText = ""
        for log in appState.logs {
            logsText += log
            logsText += "\n"
        }
        if redacted {
            logsText = logsText.replacingOccurrences(of: appState.apiKey, with: "********APIKEY*****")
        } else {
            logsText += "\n API KEY: \"\(appState.apiKey)\""
        }

        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(logsText, forType: .string)
    }
}
