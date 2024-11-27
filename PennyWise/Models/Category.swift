//
//  Category.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id: UUID?
    var name: String
    var allocatedAmount: Double
    var periodicity: String
    var emoji: String?
    var createdAt: Date
    var userId: UUID

    var periodicityEnum: Periodicity {
        get {
            Periodicity(rawValue: periodicity) ?? .monthly
        }
        set {
            periodicity = newValue.rawValue
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, name, periodicity, emoji // Include the emoji field
        case allocatedAmount = "allocated_amount"
        case createdAt = "created_at"
        case userId = "user_id"
    }
}
