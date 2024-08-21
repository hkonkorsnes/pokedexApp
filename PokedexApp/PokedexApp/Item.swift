//
//  Item.swift
//  PokedexApp
//
//  Created by Håkon Korsnes on 21/08/2024.
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
