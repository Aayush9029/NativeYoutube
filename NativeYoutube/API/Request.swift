//
//  Request.swift
//  NativeYoutube
//
//  Created by Erik Bautista on 2/5/22.
//

import Foundation
import SwiftyJSON

protocol Request {
    associatedtype T

    func createURL() -> URL?
    static func parseJSON(json: JSON) -> [T]
}
