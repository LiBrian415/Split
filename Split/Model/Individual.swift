//
//  Individual.swift
//  Split
//
//  Created by Brian Li on 7/7/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import Foundation

class Individual {
    var name: String
    var costs: [Item]

    init(name: String, costs: [Item]) {
        self.name = name
        self.costs = costs
    }
    
    func totalAmount() -> Double {
        var share = 0.00
        
        for cost in costs {
            share += cost.cost
        }
        
        if Total.total == 0.0 {
            return (share*100).rounded()/100
        } else {
            let percentOfBill = share/Total.total
            let tip = Total.total*(Double(Total.tipPercentage)/100)
            
            return ((percentOfBill*(Total.total+tip))*100).rounded()/100
        }
    }
}

