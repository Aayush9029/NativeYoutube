//
//  Enums.swift
//  NativeYoutube
//
//  Created by Adélaïde Sky on 23/12/2022.
//

import Foundation

// Didn't knew where to put it so i created this file lol

// All behaviours available on double clicking a video element.
enum VideoClickBehaviour: String, CaseIterable {
    case nothing = "Do Nothing"
    case playVideo = "Play Video"
    case openOnYoutube = "Open on Youtube"
    case playInIINA = "Play Using IINA"
}
