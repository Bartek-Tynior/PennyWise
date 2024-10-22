//
//  CategoryViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 22/10/2024.
//

import Foundation
import Supabase

final class CategoryViewModel: ObservableObject {
    @Published var categories = [Category]()
    
    private let supabaseService = SupabaseService.shared

    func fetchCategories() async throws {
        let categories: [Category] = try await supabaseService.getClient()
            .from("categories")
            .select()
            .execute()
            .value
        
        DispatchQueue.main.async {
            self.categories = categories
        }
    }
    
    func addCategory(_ category: Category) async throws {
        try await supabaseService.getClient()
            .from("categories")
            .insert(category)
            .execute()
    }
    
    func updateCategory(_ category: Category) async throws {
        
        guard let id = category.id else {
            print ("Error: Can't update category \(String(describing: category.id))")
            return
        }
        
        var toUpdate = category
        
        do {
            try await supabaseService.getClient()
                .from("categories")
                .update(toUpdate)
                .eq("id", value: id)
                .execute()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func deleteCategory(at id: String) async throws {
        try await supabaseService.getClient()
            .from("categories")
            .delete()
            .eq("id", value: id)
            .execute()
    }
}
