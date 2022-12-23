//
//  Collections+Extension.swift
//  NativeYoutube
//
//  Created by Aayush Pokharel on 2021-10-29.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript(safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
