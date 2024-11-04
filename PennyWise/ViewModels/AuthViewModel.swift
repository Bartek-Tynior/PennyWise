//
//  AuthViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 08/10/2024.
//

import Auth
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name = ""
    @Published var profile: [Profile]?

    private let supabaseService = SupabaseService.shared

    // Fetch user profile
    func fetchUserProfile() async throws {
        guard let userId = supabaseService.getClient().auth.currentUser?.id else {
            print("Error: User not authenticated.")
            return
        }

        let profile: [Profile] = try await supabaseService.getClient()
            .from("profiles")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value

        self.profile = profile
    }

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

    func updatePassword(currentPassword: String, newPassword: String) async throws {
        try await supabaseService.getClient().auth.update(user: UserAttributes(password: newPassword))
    }

    // Validate email using a regular expression
    func validEmail() -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let isEmailValid = email.range(of: emailRegex, options: .regularExpression) != nil
        return isEmailValid
    }

    // Validate password using a regular expression
    func validPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*\\.).{8,}$"
        let isPasswordValid = password.range(of: passwordRegex, options: .regularExpression) != nil
        return isPasswordValid
    }
}
