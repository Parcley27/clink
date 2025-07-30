//
//  ContentView.swift
//  Clink
//
//  Created by Pierce Oxley on 20/4/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var cashDrawer: [Denomination] = Denomination.createDrawer()
    
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
                DrawerView(drawer: $cashDrawer)
                
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
