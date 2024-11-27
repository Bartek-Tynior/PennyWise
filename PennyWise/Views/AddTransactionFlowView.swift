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
    @State private var isSaving = false

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
                    selectedAmount: $amount,
                    selectedCategoryId: $selectedCategoryId,
                    transactionDescription: $transactionDescription,
                    onAddTransaction: {
                        Task {
                            await saveTransaction()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }

            if isSaving {
                ProgressView("Saving transaction...")
                    .padding()
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            Task {
                // Fetch categories when the view appears
                try? await appDataViewModel.fetchCategories()
            }
        }
    }

    private func saveTransaction() async {
        guard let selectedCategoryId = selectedCategoryId,
              let userId = SupabaseService.shared.getClient().auth.currentUser?.id,
              !amount.isEmpty,
              let amountDouble = Double(amount)
        else {
            print("Invalid input for transaction or user not logged in")
            return
        }

        let transaction = Transaction(
            amount: amountDouble,
            description: transactionDescription,
            createdAt: Date(),
            userId: userId,
            categoryId: UUID(uuidString: selectedCategoryId)!
        )

        isSaving = true

        // Append the transaction immediately for a real-time UI update
        appDataViewModel.transactions.append(transaction)

        // Save transaction to the database
        do {
            try await appDataViewModel.addTransaction(transaction)

            // Refresh from the database after saving to ensure consistency
            try await appDataViewModel.fetchTransactions()
        } catch {
            print("Error saving transaction to the database: \(error.localizedDescription)")
            // Remove transaction if saving fails
            appDataViewModel.transactions.removeAll { $0.id == transaction.id }
        }

        isSaving = false
    }
}
