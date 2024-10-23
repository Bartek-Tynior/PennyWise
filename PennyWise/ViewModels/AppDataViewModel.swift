//
//  AppDataViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 23/10/2024.
//

import Foundation
import Combine

@MainActor
final class AppDataViewModel: ObservableObject {
    @Published var categories = [Category]()
    @Published var transactions = [Transaction]()
    
    private let supabaseService = SupabaseService.shared

    // Fetch both categories and transactions
    func fetchAllData() async throws {
        async let categories = fetchCategories()
        async let transactions = fetchTransactions()
        
        // Await both calls and update data accordingly
        self.categories = try await categories
        self.transactions = try await transactions
    }
    
    // Fetch categories
    private func fetchCategories() async throws -> [Category] {
        let categories: [Category] = try await supabaseService.getClient()
            .from("categories")
            .select()
            .execute()
            .value
        return categories
    }
    
    // Fetch transactions
    private func fetchTransactions() async throws -> [Transaction] {
        let transactions: [Transaction] = try await supabaseService.getClient()
            .from("transactions")
            .select()
            .execute()
            .value
        return transactions
    }
    
    // Add category
    func addCategory(_ category: Category) async throws {
        try await supabaseService.getClient()
            .from("categories")
            .insert(category)
            .execute()
        
        // Refresh categories after adding a new one
        try await fetchAllData()
    }
    
    // Update category
    func updateCategory(_ category: Category) async throws {
        guard let id = category.id else {
            print("Error: Can't update category \(String(describing: category.id))")
            return
        }
        
        try await supabaseService.getClient()
            .from("categories")
            .update(category)
            .eq("id", value: id)
            .execute()
        
        // Refresh categories after updating
        try await fetchAllData()
    }
    
    // Delete category
    func deleteCategory(at id: UUID) async throws {
        try await supabaseService.getClient()
            .from("categories")
            .delete()
            .eq("id", value: id)
            .execute()
        
        // Refresh categories after deleting
        try await fetchAllData()
    }
    
    // Add transaction
    func addTransaction(_ transaction: Transaction) async throws {
        try await supabaseService.getClient()
            .from("transactions")
            .insert(transaction)
            .execute()
        
        // Refresh transactions after adding a new one
        try await fetchAllData()
    }
}
