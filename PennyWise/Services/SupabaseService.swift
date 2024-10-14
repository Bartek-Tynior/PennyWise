//
//  SupabaseService.swift
//  PennyWise
//
//  Created by Bart Tynior on 08/10/2024.
//

import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
        
    private let client: SupabaseClient
    private let supabaseUrl = Secrets.projectUrl
    private let supabaseKey = Secrets.apiKey

    private init() {
        client = SupabaseClient(supabaseURL: supabaseUrl!, supabaseKey: supabaseKey)
    }
        
    func getClient() -> SupabaseClient {
        return client
    }
    
    // Sign up a new user with email and password
    func signUp(email: String, password: String) async throws -> User {
        let client = SupabaseService.shared.getClient()
            
        let result = try await client.auth.signUp(
            email: email,
            password: password
        )
            
        return result.user
    }
    
    // Sign in an existing user with email and password
    func signIn(email: String, password: String) async throws -> User {
        let client = SupabaseService.shared.getClient()
            
        let result = try await client.auth.signIn(
            email: email,
            password: password
        )
            
        return result.user
    }
}
