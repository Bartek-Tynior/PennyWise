//
//  Transaction.swift
//  PennyWise
//
//  Created by Bart Tynior on 17/10/2024.
//

import Foundation

struct Transaction: Identifiable, Codable, Hashable {
    var id: Int?
    var amount: Double
    var description: String
    var createdAt: Date
    var userId: UUID
    var categoryId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, amount, description
        case createdAt = "created_at"
        case userId = "user_id"
        case categoryId = "category_id"
    }
}
