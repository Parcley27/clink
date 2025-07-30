//
//  DrawerView.swift
//  Clink
//
//  Created by Pierce Oxley on 29/7/25.
//

import SwiftUI

struct DrawerView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var drawer: [Denomination]
    
    @State private var selectedBaseCoinName: String = "quarters"
    @State private var rollValue: Double = 0
    @State private var rollCount: Int = 0
    
    private let sectionOrder = ["bill", "coin", "roll"]
    
    let formatter: NumberFormatter = {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format
        
    }()
    
    var body: some View {
        VStack {
            let groupedDenominations = Dictionary(grouping: drawer, by: \.moneyType)
            
            ForEach(sectionOrder, id: \.self) { moneyType in
                if let denominations = groupedDenominations[moneyType] {
                    HStack {
                        RoundedRectangle(cornerRadius: 1)
                            .frame(minWidth: 10, maxWidth: .infinity, maxHeight: 1)
                            .foregroundStyle(Color.gray)
                        
                        Text("\(moneyType.capitalized)s")
                            .font(.title3)
                            .bold()
                        
                        RoundedRectangle(cornerRadius: 1)
                            .frame(minWidth: 10, maxWidth: .infinity, maxHeight: 1)
                            .foregroundStyle(Color.gray)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                    
                    ForEach(denominations.indices, id: \.self) { index in
                        let denominationIndex = drawer.firstIndex { $0.id == denominations[index].id }!
                       
                        VStack {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 1)
                                        .frame(minWidth: 10, maxWidth: .infinity, maxHeight: 1)
                                        .foregroundStyle(Color.gray)
                                    
                                    HStack {
                                        Text(drawer[denominationIndex].name)
                                            .bold()
                                            .lineLimit(0)
                                            .padding(.trailing, 8)
                                            .background(.background)
                                        
                                        Spacer()
                                        
                                    }
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text(formatter.string(from: drawer[denominationIndex].value as NSNumber) ?? "$0.00")
                                            .bold()
                                            .lineLimit(0)
                                            .padding(.leading, 8)
                                            .background(.background)
                                        
                                    }
                                    
                                }
                                
                            }
                           
                            HStack(spacing: 0) {
                                TextField("Count", value: $drawer[denominationIndex].count, formatter: NumberFormatter())
                                   .keyboardType(.numberPad)
                                   .textFieldStyle(.roundedBorder)
                               
                                Stepper("", value: $drawer[denominationIndex].count, in: 0 ... 1000)
                                
                            }
                        }
                        .padding()
                        
                    }
                }
            }
            
        }
        .monospaced()
            
    }
}

#Preview {
    @Previewable @State var demoDrawer: [Denomination] = Denomination.createDrawer()
    
    ScrollView() {
        DrawerView(drawer: $demoDrawer)
        
    }
}
