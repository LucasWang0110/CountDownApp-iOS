//
//  Item.swift
//  CountDownApp
//
//  Created by lucas on 2024/8/1.
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
