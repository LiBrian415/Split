//
//  Individual.swift
//  splitv02
//
//  Created by Brian Li on 8/4/18.
//  Copyright © 2018 Brian Li. All rights reserved.
//

import Foundation

class Individual {
    var name: String
    var costs: [Item]
    var portions: [Int]
    
    init(name: String, costs: [Item], portions: [Int]) {
        self.name = name
        self.costs = costs
        self.portions = portions
    }
    
    func totalAmount() -> Double {
        var share = 0.00
        
        for cost in costs {
            share += cost.cost
        }
        
        for i in 0..<portions.count {
            if(portions[i] != 0){
                share += (Double(portions[i])*Data.items[i].cost)/Double(Data.items[i].totalPortions)
            }
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
