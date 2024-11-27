//
//  CategoryRecommendation.swift
//  PennyWise
//
//  Created by Bart Tynior on 29/10/2024.
//

import Foundation

struct CategoryRecommendation: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var allocatedAmount: Double
    var emoji: String
    var periodicity: String
    
    // Computed property for working with Periodicity enum
    var periodicityEnum: Periodicity {
        get {
            Periodicity(rawValue: periodicity) ?? .monthly
        }
        set {
            periodicity = newValue.rawValue
        }
    }
}
