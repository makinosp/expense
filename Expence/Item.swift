//
//  Item.swift
//  Expence
//
//  Created by makinosp on 2025/01/17.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
