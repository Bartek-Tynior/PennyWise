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
    @Published var errorMessage: String? // For error display

    private let supabaseService = SupabaseService.shared

    // Sign up a new user and create their profile
    func signUp() async {
        do {
            // Sign up the user
            let newUser = try await supabaseService.signUp(email: email, password: password)

            // Create the user profile
            let newProfile = Profile(
                userId: newUser.id,
                name: name,
                email: email,
                createdAt: Date(),
                chosenCurrency: "USD" // Default currency; customize as needed
            )
            try await AppDataViewModel().createUsersProfile(newProfile)

            // Authenticate and check the session
            await checkSession()
        } catch {
            handleError(error)
        }
    }

    // Log in an existing user
    func signIn() async {
        do {
            _ = try await supabaseService.signIn(email: email, password: password)
            await checkSession()
        } catch {
            handleError(error)
        }
    }

    // Log out the current user
    func signOut() async {
        do {
            try await supabaseService.getClient().auth.signOut()
            isAuthenticated = false
        } catch {
            handleError(error)
        }
    }

    // Check if a user session exists and fetch the profile
    func checkSession() async {
        guard let user = supabaseService.getClient().auth.currentUser else {
            isAuthenticated = false
            return
        }

        do {
            try await fetchUserProfile()
            isAuthenticated = true
        } catch {
            handleError(error)
        }
    }

    // Fetch the user profile from the database
    func fetchUserProfile() async throws {
        guard let userId = supabaseService.getClient().auth.currentUser?.id else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])
        }

        let profile: [Profile] = try await supabaseService.getClient()
            .from("profiles")
            .select()
            .eq("user_id", value: userId)
            .execute()
            .value

        self.profile = profile
    }
    
    func updatePassword(currentPassword: String, newPassword: String) async throws {
        
    }

    // Handle errors and update the errorMessage
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        print("Error: \(error.localizedDescription)")
    }

    // Validate email format
    func validEmail() -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }

    // Validate password format
    func validPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*\\.).{8,}$"
        return password.range(of: passwordRegex, options: .regularExpression) != nil
    }
    
    func updateProfile(_ profile: Profile) async throws {
        do {
            try await supabaseService.getClient()
                .from("profiles")
                .update([
                    "name": profile.name,
                    "email": profile.email,
                    "chosen_currency": profile.chosenCurrency
                ])
                .eq("user_id", value: profile.userId)
                .execute()
            
            // Optionally refresh the profile
            try await fetchUserProfile()
        } catch {
            handleError(error)
            throw error
        }
    }
}

