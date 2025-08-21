//
//  CountCheckComponent.swift
//  CountCheckViews
//
//  Created by Sebastian Presno Alvarado  on 18/08/25.
//

import SwiftUI

struct CountCheckComponent: View {
    @Binding var level: Level
    @Binding var selectedAddLevel: Level
    @Binding var showAddSheet : Bool
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .shadow(radius: 3)
                .foregroundStyle(Color(UIColor.systemBackground))
            VStack{
                if level.isConfirmed {
                    summaryView
                } else {
                    fullView
                }
            }
            .padding()
            .animation(.easeInOut, value: level.isConfirmed)
        }
        .animation(.easeInOut(duration: 0.4), value: level.isConfirmed)
//        .animation(.easeInOut(duration: 0.4), value: productIDs.count)
    }
    
    private var fullView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Level \(level.level)")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    selectedAddLevel = level
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                .padding(.leading, 10)
            }
            .padding(.bottom, 8)
            
            // product row
            ForEach(Array(level.products.keys), id: \.self) { key in
                VStack(spacing: 10) {
                    Divider()
                        .frame(height: 1)
                        .background(Color.gray)
                    
                    productName(product: key)

                    counterSection(for: key)
                        .padding(.bottom, key == Array(level.products.keys).last ? 0 : 16)
                }
            }
            Divider()
                .frame(height: 1)
                .background(Color.gray)
                .padding(.top)
            // Confirm button
            Button {
                withAnimation {
                    removeZeroQuantityProducts()
                    level.isConfirmed = true
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 50)
                        .foregroundStyle(.green)
                    Text("Confirm")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 20)
        }
    }
    
    private var summaryView: some View {
        VStack(spacing: 0) {
            if level.products.filter({ $0.value > 0 }).isEmpty {
                Text("No products in level \(level)")
                    .foregroundColor(.primary)
                    .italic()
            } else {
                ForEach(Array(level.products.filter { $0.value > 0 }.keys), id: \.self) { productKey in
                    HStack {
                        productName(product: productKey)
                        
                        Spacer()
                        
                        Text("\(level.products[productKey] ?? 0)")
                            .foregroundColor(.primary)
                            .font(.system(size: 28, weight: .bold))
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                    }
                    if productKey != Array(level.products.filter { $0.value > 0 }.keys).last {
                        Divider()
                            .background(.gray)
                            .frame(height: 1)
                            .padding(.vertical, 6)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                level.isConfirmed = false
            }
        }
    }
    
    // MARK: - Helper Functions
    private func removeZeroQuantityProducts() {
        level.products = level.products.filter { $0.value > 0 }
    }
    
    // MARK: - Counter View
    private func counterSection(for productKey: String) -> some View {
        HStack{
            // subtract
            Button {
                if let currentCount = level.products[productKey], currentCount > 0 {
                    level.products[productKey] = currentCount - 1
                }
            } label: {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.blue)
                    .frame(width: 60, height: 60)
            }
            Spacer()
            // counter
            Text("\(level.products[productKey] ?? 0)")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            // add
            Button {
                level.products[productKey] = (level.products[productKey] ?? 0) + 1
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.blue)
                    .frame(width: 60, height: 60)
            }
        }
        .padding(.horizontal, 56)
    }
    
    private func productName(product: String) -> some View {
        HStack(spacing: 0){
            Text("Product: ")
                .foregroundColor(.secondary)
                .bold()
                .font(.system(size: 21, weight: .medium))
            Text(product)
                .foregroundColor(.primary)
                .bold()
                .font(.system(size: 21, weight: .medium))
            Spacer()
        }
    }
}

//#Preview {
//    CountCheckComponent(level: .constant(Level(level: 1,
//                                     products: ["ST242211": 16],
//                                     centerBoxes: [:],
//                                     byFace: ["back" : ["ST242211": 8], "front" : ["ST242211": 8]])))
//}

struct StatefulPreviewWrapper<Value>: View {
    @State var value: Value
    var content: (Binding<Value>) -> AnyView
    
    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> some View) {
        self._value = State(wrappedValue: initialValue)
        self.content = { binding in AnyView(content(binding)) }
    }
    
    var body: some View {
        content($value)
    }
}
