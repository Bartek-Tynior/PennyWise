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

    // Fetch both categories and transactions for the current user
    func fetchAllData() async throws {
        async let categories = fetchCategories()
        async let transactions = fetchTransactions()
        
        // Await both calls and update data accordingly
        self.categories = try await categories
        self.transactions = try await transactions
    }
    
    // Fetch categories for the current user
    private func fetchCategories() async throws -> [Category] {
        guard let userId = supabaseService.getClient().auth.currentUser?.id else {
            print("Error: User not authenticated.")
            return []
        }
        
        let categories: [Category] = try await supabaseService.getClient()
            .from("categories")
            .select()
            .eq("user_id", value: userId) // Filter by user ID
            .execute()
            .value
        return categories
    }
    
    // Fetch transactions for the current user
    private func fetchTransactions() async throws -> [Transaction] {
        guard let userId = supabaseService.getClient().auth.currentUser?.id else {
            print("Error: User not authenticated.")
            return []
        }
        
        let transactions: [Transaction] = try await supabaseService.getClient()
            .from("transactions")
            .select()
            .eq("user_id", value: userId) // Filter by user ID
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
    
    // Add user profile
        func createUsersProfile(_ profile: Profile) async throws {
            try await supabaseService.getClient()
                .from("profiles")
                .insert(profile)
                .execute()
        }

        // Add multiple new categories for a new user
        func addNewCategories(_ categories: [CategoryRecommendation]) async throws {
            guard let userId = supabaseService.getClient().auth.currentUser?.id else {
                throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])
            }

            let newCategories = categories.map { recommendation in
                Category(
                    id: UUID(),
                    name: recommendation.name,
                    allocatedAmount: recommendation.allocatedAmount,
                    periodicity: recommendation.periodicity,
                    createdAt: Date(),
                    userId: userId
                )
            }

            try await supabaseService.getClient()
                .from("categories")
                .insert(newCategories)
                .execute()
        }
    
    // Bulk update categories
    func updateCategories(_ categories: [Category]) async throws {
        for category in categories {
            try await updateCategory(category)
        }
        
        // Refresh categories after update
        try await fetchAllData()
    }
    
    // Single category update function
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
    
    func createUsersProfiel(_ Profile: Profile) async throws {
        try await supabaseService.getClient()
            .from("profiles")
            .insert(Profile)
            .execute()
    }
}
