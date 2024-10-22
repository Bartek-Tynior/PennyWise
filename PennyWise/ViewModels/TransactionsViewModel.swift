//
//  TransactionsViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 22/10/2024.
//

import Foundation
import Supabase

final class TransactionsViewModel: ObservableObject {
    @Published var transactions = [Transaction]()
    
    private let supabaseService = SupabaseService.shared

    func fetchTransactions() async throws {
        let transactions: [Transaction] = try await supabaseService.getClient()
            .from("transactions")
            .select()
            .execute()
            .value
        
        DispatchQueue.main.async {
            self.transactions = transactions
        }
    }
    
    func addTransaction(_ transaction: Transaction) async throws {
        try await supabaseService.getClient()
            .from("transactions")
            .insert(transaction)
            .execute()
    }
}
