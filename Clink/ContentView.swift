//
//  ContentView.swift
//  Clink
//
//  Created by Pierce Oxley on 20/4/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var cashDrawer: [Denomination] = [
        Denomination("hundreds", 100, "bill"),
        Denomination("fifties", 50, "bill"),
        Denomination("twenties", 20, "bill"),
        Denomination("tens", 10, "bill"),
        Denomination("fives", 5, "bill"),
        Denomination("toonies", 2, "coin"),
        Denomination("loonies", 1, "coin"),
        Denomination("quarters", 0.25, "coin"),
        Denomination("dimes", 0.10, "coin"),
        Denomination("nickles", 0.05, "coin")
        
    ]
    
    @State private var showReceipt: Bool = true
    @State private var selectedDetent: PresentationDetent = .fraction(0.18)
//    @State private var selectedDetent: PresentationDetent = .fraction(0.93)
    
    @State private var selectedBaseCoinName: String = "quarters"
    @State private var rollValue: Double = 0
    @State private var rollCount: Int = 0
    
    let formatter: NumberFormatter = {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format
        
    }()
    
    var total: Double {
        cashDrawer.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    var billsTotal: Double {
        cashDrawer.filter { $0.moneyType == "bill" }.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    
    var coinsTotal: Double {
        cashDrawer.filter { $0.moneyType == "coin" }.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    var rollsTotal: Double {
        cashDrawer.filter { $0.moneyType == "roll" }.reduce(0) { $0 + Double($1.count) * $1.value }
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("¢link")
                    .font(.largeTitle)
                    .bold()
                    .monospaced()
                
                Spacer()
                
                Button {
                    for i in cashDrawer.indices {
                        cashDrawer[i].count = 0
                        
                    }
                    
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .imageScale(.large)
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                }
            }
            .padding()
            
            ScrollView {
                ForEach($cashDrawer) { $item in
                    VStack {
                        HStack {
                            Text(item.name.capitalized)
                                .font(.headline)
                            
                            RoundedRectangle(cornerRadius: 1)
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .foregroundStyle(Color.gray)
                            
                            Text(formatter.string(from: item.value as NSNumber) ?? "$0.00")
                            
                        }
                        
                        HStack(spacing: 0) {
                            TextField("Count", value: $item.count, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                            
                            Stepper("", value: $item.count, in: 0 ... 1000)
                            
                        }
                        
                    }
                    .padding()
                    
                }
                
                VStack {
                    HStack {
                        Text("Roll of")
                            .font(.headline)
                        
                        Menu {
                            Picker("Coin Type", selection: $selectedBaseCoinName) {
                                ForEach(cashDrawer.filter { $0.moneyType == "coin" }, id: \.name) { coin in
                                    HStack {
                                        Text(coin.name.capitalized)
                                        Spacer()
                                        Text("(\(formatter.string(from: coin.value as NSNumber) ?? ""))")
                                            .foregroundColor(.secondary)
                                        
                                    }
                                    .tag(coin.name)
                                    
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(InlinePickerStyle())
                            .onChange(of: selectedBaseCoinName) { oldValue, newValue in
                                if let coinValue = cashDrawer.first(where: { $0.name == selectedBaseCoinName })?.value {
                                    let multiplier = (rollValue / coinValue).rounded(.toNearestOrAwayFromZero)
                                    rollValue = multiplier * coinValue
                                    
                                }
                            }
                            
                        } label: {
                            HStack {
                                Text(selectedBaseCoinName.capitalized)
                                Image(systemName: "chevron.up.chevron.down")
                                    .imageScale(.small)
                                
                            }
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.quaternary)
                                    .opacity(0.5)
                                
                            )
                        }
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        
                        RoundedRectangle(cornerRadius: 1)
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .foregroundStyle(.gray)
                        
                    }
                    
                    HStack(spacing: 0) {
                        Text("Worth ")
                            .font(.headline)
                        
                        TextField("0.00", value: $rollValue, formatter: {
                            let f = NumberFormatter()
                            f.numberStyle = .currency
                            f.minimumFractionDigits = 2
                            f.maximumFractionDigits = 2
                            return f
                            
                        }())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.trailing)
                        
                        Stepper("", value: $rollValue, in: 0...1000, step: {
                            if let coin = cashDrawer.first(where: { $0.name == selectedBaseCoinName }) {
                                switch coin.name {
                                case "quarters": return 10.00
                                case "dimes": return 5.00
                                case "nickles": return 2.00
                                case "loonies": return 25.00
                                case "toonies": return 50.00
                                    
                                default: return coin.value
                                    
                                }
                            }
                            
                            return 0.25
                            
                        }())
                    }
                    
                    if rollValue > 0, let coin = cashDrawer.first(where: { $0.name == selectedBaseCoinName }) {
                        HStack {
                            let coinCount = Int((rollValue / coin.value).rounded())
                            Text("\(coinCount) \(coin.name)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            let standardRollValue: Double = {
                                switch coin.name {
                                case "quarters": return coin.value * 40
                                case "dimes": return coin.value * 50
                                case "nickles": return coin.value * 40
                                case "loonies": return coin.value * 25
                                case "toonies": return coin.value * 25
                                    
                                default: return 0
                                    
                                }
                            }()
                            
                            if abs(rollValue - standardRollValue) < 0.01 && standardRollValue > 0 {
                                Text("Standard Roll")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Capsule())
                                
                            }
                        }
                    }
                    
                    Button() {
                        if rollValue > 0, let selectedCoin = cashDrawer.first(where: { $0.name == selectedBaseCoinName }) {
                            let rollName = "Roll of \(selectedCoin.name.capitalized)"
                            cashDrawer.append(Denomination(rollName, rollValue, "roll", 1))
                            rollValue = 0
                            
                        }
                    } label: {
                        HStack {
                            Text("Add Roll")
                                .font(.headline)
                                .foregroundColor(rollValue > 0 ? (colorScheme == .dark ? Color.white : Color.black) : .secondary)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.gray)
                                        .opacity(0.25)
                                    
                                )
                            
                        }
                    }
                    .disabled(rollValue <= 0)
                    
                }
                .padding()
                
                VStack {
                    Text("Designed by")
                        .font(.headline)
                    
                    Text("Pierce Nestibo-Oxley")
                        .font(.title)
                        .padding(.vertical, 16)
                        .bold()
                    
                }
                .padding(.bottom, 16)
                .foregroundStyle(.background)
                
            }
            .padding(.bottom, 32)
            
        }
        .monospaced()
        
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
        }
        
        .sheet(isPresented: $showReceipt) {
            ReceiptView(drawer: $cashDrawer, selectedDetent: $selectedDetent, formatter: formatter)
                .presentationDetents([.fraction(0.18), .medium, .fraction(0.93)], selection: $selectedDetent)
                .interactiveDismissDisabled()
                .presentationCornerRadius(25)
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            
        }
    }
}

#Preview {
    ContentView()
    
}
