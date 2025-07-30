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
    let moneyType: String // "bill", "coin", "roll"
    var count: Int
    
    let id: UUID = UUID()
    
    init(_ name: String, _ value: Double, _ moneyType: String, _ count: Int = 0) {
        self.name = name
        self.value = value
        self.moneyType = moneyType
        self.count = count
        
    }
}

extension Denomination {
    static func createDrawer() -> [Denomination] {
        let drawer: [Denomination] = [
            Denomination("Hundreds", 100, "bill"),
            Denomination("Fifties", 50, "bill"),
            Denomination("Twenties", 20, "bill"),
            Denomination("Tens", 10, "bill"),
            Denomination("Fives", 5, "bill"),
            Denomination("Toonies", 2, "coin"),
            Denomination("Loonies", 1, "coin"),
            Denomination("Quarters", 0.25, "coin"),
            Denomination("Dimes", 0.10, "coin"),
            Denomination("Nickles", 0.05, "coin"),
            Denomination("Roll of Toonies", 50, "roll"),
            Denomination("Roll of Loonies", 25, "roll"),
            Denomination("Roll of Quarters", 10, "roll"),
            Denomination("Roll of Dimes", 5, "roll"),
            Denomination("Roll of Nickles", 2, "roll")
            
        ]
        
        return drawer
        
    }
}
