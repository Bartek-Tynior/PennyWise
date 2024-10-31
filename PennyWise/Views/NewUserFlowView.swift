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
    @EnvironmentObject var appDataViewModel: AppDataViewModel
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
                        try await authViewModel.signUp()
                    }
                        
                    saveNewCategories()
                        
                    Task {
                        await authViewModel.checkSession()
                    }
                    print("Flow successfully completed")
                }, onPrevious: {
                    step = .allocateBudgets
                })
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    private func saveNewCategories() {
        Task {
            try? await appDataViewModel.addNewCategories(selectedCategories)
        }
    }
}

enum SetupSteps {
    case signup
    case selectCategories
    case allocateBudgets
    case welcome
}
