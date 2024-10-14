//
//  Category.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let budget: Int
    let remaining: Int
}
