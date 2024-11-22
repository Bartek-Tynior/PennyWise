//
//  Profile.swift
//  PennyWise
//
//  Created by Bart Tynior on 31/10/2024.
//

import Foundation

struct Profile: Identifiable, Codable, Equatable {
    var id: Int?
    var userId: UUID
    var name: String
    var email: String
    var createdAt: Date
    var chosenCurrency: String
    
    // Computed property for working with Currency enum
    var currencyEnum: Currency {
        get {
            Currency(rawValue: chosenCurrency) ?? .usd
        }
        set {
            chosenCurrency = newValue.rawValue
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case createdAt = "created_at"
        case userId = "user_id"
        case chosenCurrency = "chosen_currency"
    }
}
