//
//  AuthViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 08/10/2024.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name = ""

    private let supabaseService = SupabaseService.shared

    // Sign up a new user
    func signUp() async throws {
        _ = try await supabaseService.signUp(email: email, password: password)
    }

    // Log in an existing user
    func signIn() async throws {
        _ = try await supabaseService.signIn(email: email, password: password)
        await checkSession()
    }

    // Log out the current user
    func signOut() async throws {
        try await supabaseService.getClient().auth.signOut()
        await checkSession()
    }

    // Check if a user is already logged in (e.g., from a previous session)
    func checkSession() async {
        do {
            _ = try await supabaseService.getClient().auth.session.user
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
}
