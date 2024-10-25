//
//  Periodicity.swift
//  PennyWise
//
//  Created by Bart Tynior on 25/10/2024.
//

enum Periodicity: String, CaseIterable, Identifiable {
    case monthly, weekly
    var id: String { self.rawValue }
}
