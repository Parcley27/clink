//
//  Item.swift
//  Clink
//
//  Created by Pierce Oxley on 20/4/25.
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
