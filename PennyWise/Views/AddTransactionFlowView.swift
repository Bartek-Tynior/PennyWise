//
//  AddTransactionFlowView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct AddTransactionFlowView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appDataViewModel: AppDataViewModel

    @State private var step: TransactionStep = .enterAmount
    @State private var amount = ""
    @State private var selectedCategoryId: String? = nil
    @State private var transactionDescription: String = ""
    
    var body: some View {
        VStack {
            if step == .enterAmount {
                // Amount input step
                AddTransactionAmountView(amount: $amount, onContinue: {
                    step = .selectCategory
                })
            } else if step == .selectCategory {
                // Category selection step
                SelectCategoryView(
                    selectedCategoryId: $selectedCategoryId,
                    transactionDescription: $transactionDescription,
                    onAddTransaction: {
                        saveTransaction()
                        presentationMode.wrappedValue.dismiss()
                    })
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            Task {
                // Fetch categories and transactions when the view appears
                try? await appDataViewModel.fetchAllData()
            }
        }
    }
    
    private func saveTransaction() {
        guard let selectedCategoryId = selectedCategoryId,
              let userId = SupabaseService.shared.getClient().auth.currentUser?.id,
              !amount.isEmpty,
              let amountDouble = Double(amount) else {
            print("Invalid input for transaction or user not logged in")
            return
        }

        let transaction = Transaction(
            id: nil,
            amount: amountDouble,
            description: transactionDescription,
            createdAt: Date(),
            userId: userId,
            categoryId: UUID(uuidString: selectedCategoryId)!
        )
        
        Task {
            try? await appDataViewModel.addTransaction(transaction)
        }
    }
}


enum TransactionStep {
    case enterAmount
    case selectCategory
}
