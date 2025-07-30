//
//  ArrayExtensions.swift
//  Clink
//
//  Created by Pierce Oxley on 29/7/25.
//

import Foundation

extension Array where Element == Denomination {
    var total: Double {
        self.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    var billsTotal: Double {
        self.filter { $0.moneyType == "bill" }.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    
    var coinsTotal: Double {
        self.filter { $0.moneyType == "coin" }.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    var rollsTotal: Double {
        self.filter { $0.moneyType == "roll" }.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
}

