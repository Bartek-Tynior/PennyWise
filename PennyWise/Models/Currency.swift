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
    case jpy = "JPY"
    case cad = "CAD"
    case aud = "AUD"
    case cny = "CNY"
    case inr = "INR"
    case chf = "CHF"
    case sek = "SEK"
    case nzd = "NZD"
    case zar = "ZAR"
    case brl = "BRL"
    case rub = "RUB"

    var id: String { self.rawValue }
    var displayName: String {
        // All-uppercase names
        switch self {
        case .usd: return "USD - UNITED STATES DOLLAR"
        case .eur: return "EUR - EURO"
        case .gbp: return "GBP - BRITISH POUND"
        case .jpy: return "JPY - JAPANESE YEN"
        case .cad: return "CAD - CANADIAN DOLLAR"
        case .aud: return "AUD - AUSTRALIAN DOLLAR"
        case .cny: return "CNY - CHINESE YUAN"
        case .inr: return "INR - INDIAN RUPEE"
        case .chf: return "CHF - SWISS FRANC"
        case .sek: return "SEK - SWEDISH KRONA"
        case .nzd: return "NZD - NEW ZEALAND DOLLAR"
        case .zar: return "ZAR - SOUTH AFRICAN RAND"
        case .brl: return "BRL - BRAZILIAN REAL"
        case .rub: return "RUB - RUSSIAN RUBLE"
        }
    }

    static func fromString(_ string: String) -> Currency? {
        return Currency.allCases.first { $0.rawValue == string }
    }
}
