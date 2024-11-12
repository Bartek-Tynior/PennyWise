//
//  Currency.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/11/2024.
//

enum Currency: String, CaseIterable, Identifiable, Equatable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    // Add other currencies as needed

    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .usd: return "USD - United States Dollar"
        case .eur: return "EUR - Euro"
        case .gbp: return "GBP - British Pound"
        // Define display names for each currency
        }
    }

    static func fromString(_ string: String) -> Currency? {
        return Currency.allCases.first { $0.rawValue == string }
    }
}
