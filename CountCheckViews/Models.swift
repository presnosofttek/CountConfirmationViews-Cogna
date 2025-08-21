//
//  Models.swift
//  CountCheckViews
//
//  Created by Juan Ignacio Lebrija Muraira on 20/08/25.
//

import Foundation

struct Tower: Decodable, Hashable{
    var levels: [Level]
    var allConfirmed: Bool {
        levels.allSatisfy { $0.isConfirmed }
    }
}

struct Level: Decodable, Hashable {
    let level: Int
    var total: Int {
        products.values.reduce(0, +)
    }
    var products: [String: Int]
    let centerBoxes: [String: Int]
    let byFace: [String: [String: Int]]
    var isConfirmed = false
}

extension Level: CustomStringConvertible {
    var description: String {
        "Level \(level), products: \(products), total: \(total), isConfirmed: \(isConfirmed)"
    }
}
