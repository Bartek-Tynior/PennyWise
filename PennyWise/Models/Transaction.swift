//
//  Transaction.swift
//  PennyWise
//
//  Created by Bart Tynior on 17/10/2024.
//

import Foundation

struct Transaction: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let amount: Double
}
