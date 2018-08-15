//
//  Item.swift
//  splitv02
//
//  Created by Brian Li on 8/5/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import Foundation

struct Item: Hashable {
    var name: String = ""
    var cost: Double = 0.0
    var isPortioned: Bool = false
    var isSelected: Bool = false
    var totalPortions: Int = 0
    
    init(name: String, cost: Double, isPortioned: Bool = false, isSelected: Bool = false, portions: Int = 1){
        self.name = name
        self.cost = cost
    }
    
    static func == (item1: Item, item2: Item) -> Bool {
        return item1.name == item2.name && item1.cost == item2.cost
    }
}

