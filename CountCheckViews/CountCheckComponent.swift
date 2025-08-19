//
//  CountCheckComponent.swift
//  CountCheckViews
//
//  Created by Sebastian Presno Alvarado  on 18/08/25.
//

import SwiftUI

struct CountCheckComponent: View {
    let level: Int
    @Binding var boxCounts: [Int]
    @Binding var productIDs: [String]
    @Binding var addProduct: Bool
    
    let isConfirmed: Binding<Bool>
    
    // Computed property to get non-zero products for display
    private var nonZeroProducts: [(id: String, count: Int, originalIndex: Int)] {
        zip(productIDs, boxCounts).enumerated().compactMap { index, element in
            element.1 > 0 ? (id: element.0, count: element.1, originalIndex: index) : nil
        }
    }
    
    // Better height calculation
    private var calculatedHeight: CGFloat {
        if isConfirmed.wrappedValue {
            let nonZeroCount = nonZeroProducts.count
            if nonZeroCount == 0 {
                return 80 //minimum height when no products
            }
            return CGFloat(nonZeroCount * 50 + 60) // 50 per product + padding
        } else {
            let productCount = productIDs.count
            let baseHeight: CGFloat = 120
            let productHeight: CGFloat = 150
            let dividerHeight: CGFloat = 20 // between products
            
            return baseHeight + (CGFloat(productCount) * productHeight) + (CGFloat(max(0, productCount - 1)) * dividerHeight)
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray)
            .frame(width: 350)
            .overlay(
                VStack(spacing: 16) {
                    if isConfirmed.wrappedValue {
                        summaryView
                    } else {
                        fullView
                    }
                }
                    .padding()
                    .animation(.easeInOut, value: isConfirmed.wrappedValue)
            )
            .frame(height: calculatedHeight)
            .animation(.easeInOut(duration: 0.4), value: isConfirmed.wrappedValue)
            .animation(.easeInOut(duration: 0.4), value: productIDs.count)
    }
    
    private var fullView: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Level \(level)")
                    .foregroundColor(.white)
                    .font(.title2)
                Spacer()
                Button {
                    addProduct = true
                    //OPEN sheet
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                }
                .padding(.leading, 10)
            }
            
            ForEach(productIDs.indices, id: \.self) { index in
                VStack(spacing: 10) {
                    Text("Product: \(productIDs[index])")
                        .foregroundColor(.black)
                        .bold()
                        .font(.system(size: 21, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    counterSection(forIndex: index)
                    
                    if index < productIDs.count - 1 {
                        Divider()
                            .background(Color.white)
                            .padding(.top)
                    }
                }
            }
            // Confirm button
            Button {
                withAnimation {
                    removeZeroQuantityProducts()
                    isConfirmed.wrappedValue = true
                }
            } label: {
                Capsule()
                    .fill(Color.green)
                    .frame(width: 110, height: 40)
                    .overlay(
                        Text("Confirm")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                    )
            }
            .padding(.top, 10)
        }
    }
    
    private var summaryView: some View {
        VStack(spacing: 12) {
            if nonZeroProducts.isEmpty {
                Text("No products in level \(level)")
                    .foregroundColor(.white)
                    .italic()
            } else {
                ForEach(nonZeroProducts.indices, id: \.self) { index in
                    let product = nonZeroProducts[index]
                    HStack {
                        Text("Product: \(product.id)")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 16))
                            .padding(.leading, 10)
                        
                        Spacer()
                        
                        Text("\(product.count)")
                            .foregroundColor(.white)
                            .font(.system(size: 28, weight: .bold))
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isConfirmed.wrappedValue = false
            }
        }
    }
    
    // MARK: - Helper Functions
    private func removeZeroQuantityProducts() {
        var indicesToRemove: [Int] = []
        
        // Find indices of products with zero quantity
        for i in boxCounts.indices.reversed() {
            if boxCounts[i] == 0 {
                indicesToRemove.append(i)
            }
        }
        
        // Remove products with zero quantity (in reverse order to maintain correct indices)
        for index in indicesToRemove {
            productIDs.remove(at: index)
            boxCounts.remove(at: index)
        }
    }
    
    // MARK: - Counter View
    private func counterSection(forIndex index: Int) -> some View {
        HStack(spacing: 30) {
            Button {
                if boxCounts[index] > 0 {
                    boxCounts[index] -= 1
                }
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("-")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            
            Text("\(boxCounts[index])")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
            
            Button {
                boxCounts[index] += 1
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("+")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper([6, 3]) { boxCounts in
        CountCheckComponent(level: 1, boxCounts: boxCounts, productIDs: .constant(["12345", "67890"]), addProduct: .constant(false), isConfirmed: .constant(false))
    }
}

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
