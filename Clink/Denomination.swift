//
//  Denomination.swift
//  Clink
//
//  Created by Pierce Oxley on 20/4/25.
//

import Foundation

struct Denomination: Identifiable {
    let name: String
    let value: Double
    let moneyType: String
    var count: Int
    
    let id: UUID = UUID()
    
    init(_ name: String, _ value: Double, _ moneyType: String, _ count: Int = 0) {
        self.name = name
        self.value = value
        self.moneyType = moneyType
        self.count = count
        
    }
}
