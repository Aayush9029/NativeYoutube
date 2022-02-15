//
//  URL+Extension.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/14/22.
//

import Foundation

extension URL {
    var isDeeplink: Bool {
        return scheme == "nativeyoutube"
    }
}
