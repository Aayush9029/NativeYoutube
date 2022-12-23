//
//  String+Time.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/3/22.
//

import Foundation

extension String {
    init(timeInterval: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let hasHour = (timeInterval / (60 * 60)) > 1
        if hasHour {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }

        if let timeString = formatter.string(from: timeInterval) {
            self.init(timeString)
        } else {
            self.init("0:00")
        }
    }
}
