//
//  ReceiptView.swift
//  Clink
//
//  Created by Pierce Oxley on 20/4/25.
//

import SwiftUI

struct ReceiptView: View {
    @Binding var drawer: [Denomination]
    @Binding var selectedDetent: PresentationDetent
    
    let formatter: NumberFormatter
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Text("Summary")
                        .font(.title3)
                        .bold()
                        .padding(.top)
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(Color.gray)
                        .padding(.horizontal)
                    
                    ScrollView {
                        if drawer.reduce(0, {$0 + $1.count}) == 0 {
                            Text("Add items first to view them on the reciept...")
                                .padding()
                            
                        }
                        
                        VStack {
                            ForEach(drawer.filter { $0.count > 0 }) { item in
                                VStack {
                                    HStack {
                                        Text(item.name)
                                            .font(.headline)
                                        
                                        RoundedRectangle(cornerRadius: 1)
                                            .frame(maxWidth: .infinity, maxHeight: 1)
                                            .foregroundStyle(Color.gray)
                                        
                                    }
                                    
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Text("\(item.count) × \(formatter.string(from: item.value as NSNumber) ?? "")")
                                        
                                        Text("=")
                                        
                                        Text(formatter.string(from: NSNumber(value: Double(item.count) * item.value)) ?? "")
                                        
                                    }
                                    
                                }
                                .padding(.bottom, 8)
                                .font(.callout)
                                
                            }
                        }
                        .padding()
                        .transition(.move(edge: .top))
                        
                    }
                    
                    RoundedRectangle(cornerRadius: 1)
                        .frame(maxWidth: .infinity, maxHeight: 1)
                        .foregroundStyle(Color.gray)
                        .padding(.horizontal)
                    
                }
                .frame(maxHeight: max(0, geo.size.height - 155))
                .clipped()
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("Total: \(formatter.string(from: drawer.total as NSNumber) ?? "$0.00")")
                            .font(.title)
                            .padding(.vertical, 4)
                            .padding(.top, 16)
                            .bold()
                        
                        HStack(spacing: 32) {
                            VStack {
                                Text("\(formatter.string(from: drawer.billsTotal as NSNumber) ?? "$0.00")")
                                    .font(.headline)
                                
                                Divider()
                                
                                Text("Bills")
                                
                            }
                            
                            VStack {
                                Text("\(formatter.string(from: drawer.coinsTotal as NSNumber) ?? "$0.00")")
                                    .font(.headline)
                                
                                Divider()
                                
                                Text("Coins")
                                
                            }
                            
                            VStack {
                                Text("\(formatter.string(from: drawer.rollsTotal as NSNumber) ?? "$0.00")")
                                    .font(.headline)
                                
                                Divider()
                                
                                Text("Rolls")
                                
                            }
                            
                        }
                        //.padding(.bottom, 8)
                        .padding(.all, 8)
                        
                    }
                    
                    Spacer()
                }
            }
            .monospaced()
            
        }
    }
}
    
    
#Preview {
    @Previewable @State var demoDrawer: [Denomination] = Denomination.createDrawer()
    
    @Previewable @State var detent: PresentationDetent = PresentationDetent.fraction(0.18)
//    let selectedDetent = PresentationDetent.medium
//    let selectedDetent = PresentationDetent.fraction(0.93)
    
    let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }()
    
    ReceiptView(drawer: $demoDrawer, selectedDetent: $detent, formatter: formatter)
    
}
