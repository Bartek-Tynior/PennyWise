//
//  Category.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: Int?
    var name: String
    var allocatedAmount: Double
    var periodicity: String
    var createdAt: Date
    var userId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, name, periodicity
        case allocatedAmount = "allocted_amount"
        case createdAt = "created_at"
        case userId = "user_id"
    }
}
