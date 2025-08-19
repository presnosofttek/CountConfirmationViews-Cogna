//
//  CountConfirmationView.swift
//  CountCheckViews
//
//  Created by Sebastian Presno Alvarado  on 18/08/25.
//

import SwiftUI

struct CountConfirmationView: View {
    // Each sub-array represents counts for that level's products
    @State private var boxCountsByLevel: [[Int]] = [
        [6, 0],     // Level 1: 2 products
        [4],        // Level 2: 1 product
        [2, 0, 0]   // Level 3: 3 products
    ]

    @State private var confirmedLevels: [Bool] = [false, false, false]
    
    @State var addProduct : Bool = false
    
    @State private var selectedAddLevel: Int = 0

    // Product IDs for each level
    @State private var productIDsByLevel: [[String]] = [
        ["12345", "67890"],
        ["54321"],
        ["11111", "22222", "33333"]
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Box Confirmation")
                    .font(.largeTitle)
                    .padding(.top)
                
                ForEach(0..<boxCountsByLevel.count, id: \.self) { index in
                    CountCheckComponent(
                        level: index + 1,
                        boxCounts: $boxCountsByLevel[index],
                        productIDs: $productIDsByLevel[index],
                        addProduct: Binding(
                            get: { addProduct && selectedAddLevel == index },
                            set: { newValue in
                                if newValue {
                                    selectedAddLevel = index
                                    addProduct = true
                                } else {
                                    addProduct = false
                                }
                            }
                        ),
                        isConfirmed: $confirmedLevels[index]
                    )
                }
                
                Spacer()
                
                HStack {
                    Button("Cancel") {
                        resetAll()
                    }
                    .padding()
                    .frame(width: 100)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.red.opacity(0.8), lineWidth: 2)
                    )
                    
                    Spacer()
                    
                    Button("Confirm") {
                        print("All confirmed!")
                    }
                    .padding()
                    .frame(width: 100)
                    .background(allConfirmed ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(allConfirmed ? Color.green.opacity(0.8) : Color.gray, lineWidth: 2)
                    )
                    .disabled(!allConfirmed)
                }
                .padding(.horizontal, 30)
                .padding(.bottom)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
        }
        .sheet(isPresented: $addProduct, content: {
            AddProductSheet(
                boxCountsByLevel: $boxCountsByLevel,
                productIDsByLevel: $productIDsByLevel,
                levelIndex: selectedAddLevel
            )
        })
    }

    private var allConfirmed: Bool {
        confirmedLevels.allSatisfy { $0 }
    }

    private func resetAll() {
        for i in 0..<confirmedLevels.count {
            confirmedLevels[i] = false
            // Reset counts but keep original arrays structure
            for j in 0..<boxCountsByLevel[i].count {
                boxCountsByLevel[i][j] = 0
            }
        }
    }
}

#Preview {
    CountConfirmationView()
}

/*
 TODO: integrar con tower data
 */

struct AddProductSheet: View {
    @Environment(\.dismiss) private var dismiss

    var products = ["123456", "534234", "653341", "139849"]
    @State private var selectedProduct: String = ""
    @Binding var boxCountsByLevel: [[Int]]
    @Binding var productIDsByLevel: [[String]]
    var levelIndex: Int

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Select a Product")
                .font(.title2)
                .bold()

            Text("Pick a product to add to Level \(levelIndex + 1).")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Picker("Tap to pick a product", selection: $selectedProduct) {
                ForEach(products, id: \.self) { product in
                    Text("Product ID: \(product)").tag(product)
                }
            }
            .pickerStyle(.wheel)
            .frame(maxHeight: 150)

            if !selectedProduct.isEmpty {
                Text("Selected: \(selectedProduct)")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("Product not selected")
                    .font(.headline)
                    .foregroundColor(.red)
            }

            Spacer()

            Button(action: {
                if !selectedProduct.isEmpty {
                    productIDsByLevel[levelIndex].append(selectedProduct)
                    boxCountsByLevel[levelIndex].append(0)
                }
                dismiss()
            }) {
                Text("Finish")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedProduct.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(selectedProduct.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
}
