//
//  NewUserFlowView.swift
//  PennyWise
//
//  Created by Bart Tynior on 29/10/2024.
//

import SwiftUI

struct NewUserFlowView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedCategories: [CategoryRecommendation] = []
    @State private var step: SetupSteps = .signup
    @State private var isLoading = false

    var body: some View {
        VStack {
            if step == .signup {
                SignUpView(onContinue: {
                    step = .selectCategories
                })
            } else if step == .selectCategories {
                SelectCategoriesNewUserView(selectedCategories: $selectedCategories, onContinue: {
                    step = .allocateBudgets
                })
            } else if step == .allocateBudgets {
                AllocateBudgetsNewUserView(selectedCategories: $selectedCategories, onAddCategories: {
                    step = .welcome
                }, onPrevious: {
                    step = .selectCategories
                })
            } else if step == .welcome {
                AppIntroView(onFinish: {
                    Task {
                        isLoading = true
                        do {
                            // Perform signup and profile creation
                            try await authViewModel.signUp()

                            // Save selected categories
                            try await saveNewCategories()

                            // Update session state
                            await authViewModel.checkSession()
                            print("Signup and profile creation complete")
                        } catch {
                            authViewModel.errorMessage = "Signup failed: \(error.localizedDescription)"
                        }
                        isLoading = false
                    }
                }, onPrevious: {
                    step = .allocateBudgets
                })
            }

            // Show error messages
            if let errorMessage = authViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }

            if isLoading {
                ProgressView("Loading...")
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }

    private func saveNewCategories() async throws {
        try await AppDataViewModel().addNewCategories(selectedCategories)
    }
}

