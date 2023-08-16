//
//  Collection+Extensions.swift
//  FlashFy
//
//  Created by Yasin Cetin on 15.08.2023.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
