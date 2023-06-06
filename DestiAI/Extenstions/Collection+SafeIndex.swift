//
//  Collection+SafeIndex.swift
//  DestiAI
//
//  Created by Lorand Ignat on 06.06.2023.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
