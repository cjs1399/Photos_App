//
//  Array+.swift
//  photos_app
//
//  Created by 천성우 on 2/11/25.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
