//
//  CountConfirmationView.swift
//  CountCheckViews
//
//  Created by Juan Ignacio Lebrija Muraira on 20/08/25.
//

import SwiftUI

struct CountConfirmationView: View {
    @State var tower: Tower
    @State var addProduct : Bool = false
    @State private var selectedAddLevel: Level
    @State var showAddSheet: Bool = false
    
    init(tower: Tower) {
        self.tower = tower
        self.selectedAddLevel = tower.levels[0]
    }
    var body: some View {
        ZStack{
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea(edges: .all)
            ScrollView {
                VStack(spacing: 20) {
                    // for each level
                    ForEach($tower.levels, id: \.self) { level in
                        CountCheckComponent(
                            level: level,
                            selectedAddLevel : $selectedAddLevel,
                            showAddSheet : $showAddSheet
                        )
                    }
                    Spacer()
                    // cancel and confirm
                    HStack {
                        // Cancel
                        Button {
                            resetAll()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundColor(.red)
                                    .frame(height: 60)
                                Text("Cancel")
                                    .foregroundStyle(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        // Confirm
                        Button {
                            print("All confirmed!")
                            for level in tower.levels {
                                print(level.description)
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(tower.allConfirmed ? Color.green : Color.gray)
                                    .frame(height: 60)
                                Text("Confirm")
                                    .foregroundStyle(.white)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }
                        }
                        .disabled(!tower.allConfirmed)
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .toolbar(content: {
            // header
            Text("Box Confirmation")
                .font(.largeTitle)
                .padding(.top)
        })
        .sheet(isPresented: $showAddSheet, content: {
            if let index = tower.levels.firstIndex(where: { $0.level == selectedAddLevel.level }) {
                AddProductSheet(
                    level: $tower.levels[index]
                )
                .presentationDetents([.fraction(0.5)])
            }
        })
    }
    private func resetAll() {
        print("hi")
    }
    
    struct AddProductSheet: View {
        @Environment(\.dismiss) private var dismiss
        @Binding var level: Level
        
        var products = ["123456", "534234", "653341", "139849"]
        @State private var selectedProduct: String = "123456"

        var body: some View {
            ZStack{
                Color(UIColor.systemBackground)
                
                VStack(alignment: .leading, spacing: 6) {

                    Text("Select a Product")
                        .font(.title2)
                        .bold()
                    Divider()
                        .background(.gray)
                        .frame(height: 1)
                    Text("Pick a product to add to Level \(level.level).")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Picker("Tap to pick a product", selection: $selectedProduct) {
                        ForEach(products, id: \.self) { product in
                            Text("Product ID: \(product)").tag(product)
                        }
                    }
                    .pickerStyle(.wheel)
                    .background{
                        Color(UIColor.secondarySystemBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 1)
                    }
                    .frame(maxHeight: 150)

                    Button(action: {
                        level.products[selectedProduct] = 0
                        dismiss()
                        print(level)
                    }) {
                        HStack(spacing: 0){
                            Text("Add Product ")
                            if !selectedProduct.isEmpty {
                                Text(": \(selectedProduct)")
                            }
                        }
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(selectedProduct.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(selectedProduct.isEmpty)
                    .padding(.top, 30)
                    Spacer()

                }
                .padding()
            }
            .onAppear{
                print(level)
            }
        }
    }
    
}
//"tower_0": {
//    "level_0": {
//        "total": 16,
//        "products": {
//            "ST242211": 16
//        },
//        "centerBoxes": {},
//        "byFace": {
//            "back": {
//                "ST242211": 8
//            },
//            "front": {
//                "ST242211": 8
//            }
//        }
//    },
//    "level_1": {
//        "total": 12,
//        "centerBoxes": {},
//        "byFace": {
//            "back": {
//                "ST242207": 6
//            },
//            "front": {
//                "ST242207": 6
//            }
//        },
//        "products": {
//            "ST242207": 12
//        }
//    }
//}



#Preview {
    CountConfirmationView(tower: Tower(levels: [
        Level(level: 0,
              products: ["ST242211": 16],
              centerBoxes: [:],
              byFace: ["back" : ["ST242211": 8], "front" : ["ST242211": 8]]),
        Level(level: 1,
              products: ["ST242207": 12],
              centerBoxes: [:],
              byFace: ["back" : ["ST242207": 6], "front" : ["ST242207": 6]]),
    ]))
}

