//
//  Item.swift
//  Behind-The-Reefs
//
//  Created by Hana Azizah Nurhadi on 07/05/26.
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
