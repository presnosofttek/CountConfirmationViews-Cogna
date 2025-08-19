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
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .shadow(radius: 3)
                .foregroundStyle(Color(UIColor.systemBackground))
            VStack{
                if isConfirmed.wrappedValue {
                    summaryView
                } else {
                    fullView
                }
            }
            .padding()
            .animation(.easeInOut, value: isConfirmed.wrappedValue)
        }
        .animation(.easeInOut(duration: 0.4), value: isConfirmed.wrappedValue)
        .animation(.easeInOut(duration: 0.4), value: productIDs.count)
    }
    
    private var fullView: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Level \(level)")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    addProduct = true
                    //OPEN sheet
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                }
                .padding(.leading, 10)
            }
            .padding(.bottom, 8)
            
            // product row
            ForEach(productIDs.indices, id: \.self) { index in
                VStack(spacing: 10) {
                    Divider()
                        .frame(height: 1)
                        .background(Color.gray)
                    
                    productName(product: productIDs[index])

                    counterSection(forIndex: index)
                        .padding(.bottom, index == productIDs.count - 1 ? 0 : 16)
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
                    isConfirmed.wrappedValue = true
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
            if nonZeroProducts.isEmpty {
                Text("No products in level \(level)")
                    .foregroundColor(.primary)
                    .italic()
            } else {
                ForEach(nonZeroProducts.indices, id: \.self) { index in
                    let product = nonZeroProducts[index]
                    HStack {
                        productName(product: product.id)
                        
                        Spacer()
                        
                        Text("\(product.count)")
                            .foregroundColor(.primary)
                            .font(.system(size: 28, weight: .bold))
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                    }
                    if index != nonZeroProducts.count - 1 {
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
        HStack{
            // subtract
            Button {
                if boxCounts[index] > 0 {
                    boxCounts[index] -= 1
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
            Text("\(boxCounts[index])")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            // add
            Button {
                boxCounts[index] += 1
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
