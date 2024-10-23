//
//  AddTransactionFlowView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct AddTransactionFlowView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var appDataViewModel: AppDataViewModel // Use shared view model

    @State private var step: TransactionStep = .enterAmount
    @State private var amount = ""
    @State private var selectedCategory: String? = nil
    @State private var transactionDescription: String = "" // To pass to SelectCategoryView
    
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
                    selectedCategory: $selectedCategory,
                    transactionDescription: $transactionDescription, // Bind description
                    onAddTransaction: {
                        saveTransaction()
                        presentationMode.wrappedValue.dismiss()
                    })
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    private func saveTransaction() {
        // Ensure the input data is valid before proceeding
        guard let selectedCategory = selectedCategory, !amount.isEmpty, let amountDouble = Double(amount) else {
            return // Show error or alert
        }
        
        let transation = Transaction(
            id: 2,
            amount: amountDouble,
            description: transactionDescription,
            createdAt: ,
            userId: ,
            categoryId: selectedCategory)
        )
        
        // Use appDataViewModel to add the transaction
        Task {
            try? await appDataViewModel.addTransaction(transaction)
        }
    }
}

enum TransactionStep {
    case enterAmount
    case selectCategory
}
