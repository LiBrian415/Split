//
//  Total.swift
//  Split
//
//  Created by Brian Li on 7/9/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import Foundation

struct Total {
    static var total: Double = 0.0
    static var tipPercentage: Int = 0
    
    private init(total: Double, tipPercentage: Int){
        Total.total = total
        Total.tipPercentage = tipPercentage
    }
}
