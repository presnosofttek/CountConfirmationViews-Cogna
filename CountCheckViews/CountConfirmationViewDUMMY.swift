////
////  CountConfirmationView.swift
////  CountCheckViews
////
////  Created by Sebastian Presno Alvarado  on 18/08/25.
////
//
//import SwiftUI
//
//struct CountConfirmationViewDUMMY: View {
//    var tower: Tower
//    // Each sub-array represents counts for that level's products
//    @State private var boxCountsByLevel: [[Int]] = [
//        [6, 0],     // Level 1: 2 products
//        [4],        // Level 2: 1 product
//        [2, 0, 0]   // Level 3: 3 products
//    ]
//
//    @State private var confirmedLevels: [Bool] = [false, false, false]
//    
//    @State var addProduct : Bool = false
//    
//    @State private var selectedAddLevel: Int = 0
//
//    // Product IDs for each level
//    @State private var productIDsByLevel: [[String]] = [
//        ["12345", "67890"],
//        ["54321"],
//        ["11111", "22222", "33333"]
//    ]
//    
//    var body: some View {
//        ZStack{
//            Color(UIColor.systemGroupedBackground)
//                .ignoresSafeArea(edges: .all)
//            ScrollView {
//                VStack(spacing: 20) {
//                    // for each level
//                    ForEach(0..<boxCountsByLevel.count, id: \.self) { index in
//                        CountCheckComponent(
//                            level: index + 1,
//                            boxCounts: $boxCountsByLevel[index],
//                            productIDs: $productIDsByLevel[index],
//                            addProduct: Binding(
//                                get: { addProduct && selectedAddLevel == index },
//                                set: { newValue in
//                                    if newValue {
//                                        selectedAddLevel = index
//                                        addProduct = true
//                                    } else {
//                                        addProduct = false
//                                    }
//                                }
//                            ),
//                            isConfirmed: $confirmedLevels[index]
//                        )
//                    }
//                    Spacer()
//                    // cancel and confirm
//                    HStack {
//                        // Cancel
//                        Button {
//                            resetAll()
//                        } label: {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .foregroundColor(.red)
//                                    .frame(height: 60)
//                                Text("Cancel")
//                                    .foregroundStyle(.white)
//                                    .font(.title3)
//                                    .fontWeight(.semibold)
//                            }
//                        }
//                        .buttonStyle(.plain)
//                        
//                        // Confirm
//                        Button {
//                            print("All confirmed!")
//                        } label: {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 12)
//                                    .foregroundStyle(allConfirmed ? Color.green : Color.gray)
//                                    .frame(height: 60)
//                                Text("Confirm")
//                                    .foregroundStyle(.white)
//                                    .font(.title3)
//                                    .fontWeight(.semibold)
//                            }
//                        }
//                        .disabled(!allConfirmed)
//                        .buttonStyle(.plain)
//                    }
//                }
//                .padding()
//            }
//        }
//        .toolbar(content: {
//            // header
//            Text("Box Confirmation")
//                .font(.largeTitle)
//                .padding(.top)
//        })
//        .sheet(isPresented: $addProduct, content: {
//            AddProductSheet(
//                boxCountsByLevel: $boxCountsByLevel,
//                productIDsByLevel: $productIDsByLevel,
//                levelIndex: selectedAddLevel
//            )
//            .presentationDetents([.fraction(0.5)])
//        })
//    }
//
//    private var allConfirmed: Bool {
//        confirmedLevels.allSatisfy { $0 }
//    }
//
//    private func resetAll() {
//        for i in 0..<confirmedLevels.count {
//            confirmedLevels[i] = false
//            // Reset counts but keep original arrays structure
//            for j in 0..<boxCountsByLevel[i].count {
//                boxCountsByLevel[i][j] = 0
//            }
//        }
//    }
//}
////"tower_0": {
////    "level_0": {
////        "total": 16,
////        "products": {
////            "ST242211": 16
////        },
////        "centerBoxes": {},
////        "byFace": {
////            "back": {
////                "ST242211": 8
////            },
////            "front": {
////                "ST242211": 8
////            }
////        }
////    },
////    "level_1": {
////        "total": 12,
////        "centerBoxes": {},
////        "byFace": {
////            "back": {
////                "ST242207": 6
////            },
////            "front": {
////                "ST242207": 6
////            }
////        },
////        "products": {
////            "ST242207": 12
////        }
////    }
////}
//
//struct AddProductSheet: View {
//    @Environment(\.dismiss) private var dismiss
//
//    var products = ["123456", "534234", "653341", "139849"]
//    @State private var selectedProduct: String = ""
//    @Binding var boxCountsByLevel: [[Int]]
//    @Binding var productIDsByLevel: [[String]]
//    var levelIndex: Int
//
//    var body: some View {
//        ZStack{
//            Color(UIColor.systemBackground)
//            
//            VStack(alignment: .leading, spacing: 6) {
//
//                Text("Select a Product")
//                    .font(.title2)
//                    .bold()
//                Divider()
//                    .background(.gray)
//                    .frame(height: 1)
//                Text("Pick a product to add to Level \(levelIndex + 1).")
//                    .font(.title3)
//                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.center)
//
//                Picker("Tap to pick a product", selection: $selectedProduct) {
//                    ForEach(products, id: \.self) { product in
//                        Text("Product ID: \(product)").tag(product)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .background{
//                    Color(UIColor.secondarySystemBackground)
//                        .clipShape(RoundedRectangle(cornerRadius: 8))
//                        .shadow(radius: 1)
//                }
//                .frame(maxHeight: 150)
//
//                Button(action: {
//                    if !selectedProduct.isEmpty {
//                        productIDsByLevel[levelIndex].append(selectedProduct)
//                        boxCountsByLevel[levelIndex].append(0)
//                    }
//                    dismiss()
//                }) {
//                    HStack(spacing: 0){
//                        Text("Add Product ")
//                        if !selectedProduct.isEmpty {
//                            Text(": \(selectedProduct)")
//                        }
//                    }
//                    .fontWeight(.semibold)
//                    .padding(.vertical)
//                    .frame(maxWidth: .infinity)
//                    .background(selectedProduct.isEmpty ? Color.gray : Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//                }
//                .disabled(selectedProduct.isEmpty)
//                .padding(.top, 30)
//                Spacer()
//
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    CountConfirmationViewDUMMY(tower: Tower(levels: [
//        Level(level: 0,
//              total: 16,
//              products: ["ST242211": 16],
//              centerBoxes: [:],
//              byFace: ["back" : ["ST242211": 8], "front" : ["ST242211": 8]]),
//        Level(level: 1,
//              total: 12,
//              products: ["ST242207": 12],
//              centerBoxes: [:],
//              byFace: ["back" : ["ST242207": 6], "front" : ["ST242207": 6]]),
//    ]))
//}
//
