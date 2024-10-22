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
}
