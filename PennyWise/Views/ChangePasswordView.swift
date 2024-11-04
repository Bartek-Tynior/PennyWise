//
//  ChangePasswordView.swift
//  PennyWise
//
//  Created by Bart Tynior on 31/10/2024.
//

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showSheet: Bool
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isProcessing = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Current Password")) {
                    SecureField("Enter your current password", text: $currentPassword)
                }
                
                Section(header: Text("New Password")) {
                    SecureField("Enter your new password", text: $newPassword)
                    SecureField("Confirm new password", text: $confirmPassword)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: changePassword) {
                    HStack {
                        Spacer()
                        if isProcessing {
                            ProgressView()
                        } else {
                            Text("Change Password")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .disabled(isProcessing)
            }
            .navigationTitle("Change Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSheet = false
                    }
                }
            }
        }
    }

    func changePassword() {
        guard !currentPassword.isEmpty, !newPassword.isEmpty, newPassword == confirmPassword else {
            errorMessage = "Please ensure all fields are filled in correctly."
            return
        }
        
        isProcessing = true
        errorMessage = ""
        
        Task {
            do {
                try await authViewModel.updatePassword(currentPassword: currentPassword, newPassword: newPassword)
                showSheet = false
            } catch {
                errorMessage = "Failed to change password. Please try again."
            }
            isProcessing = false
        }
    }
}
