//
//  Total.swift
//  splitv02
//
//  Created by Brian Li on 8/5/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import Foundation

struct Total {
    static var total: Double = {
        var total = 0.00
        for num in Data.items{
            total += num.cost
        }
        return total
    }()
    static var tipPercentage: Int = 15
    
    private init(total: Double, tipPercentage: Int){
        Total.total = total
        Total.tipPercentage = tipPercentage
    }
}
