//
//  AddTransactionFlowView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct AddTransactionFlowView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var step: TransactionStep = .enterAmount
    @State private var amount = ""
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        VStack {
            if step == .enterAmount {
                // Amount input step
                AddTransactionAmountView(amount: $amount, onContinue: {
                    step = .selectCategory
                })
            } else if step == .selectCategory {
                // Category selection step
                SelectCategoryView(selectedCategory: $selectedCategory, onAddTransaction: {
                    // Handle saving the transaction
                    saveTransaction()
                    presentationMode.wrappedValue.dismiss()
                })
            }
        }
    }
    
    private func saveTransaction() {
        // Add the logic to save the transaction with the amount and selected category
        print("Transaction saved with amount: \(amount) and category: \(selectedCategory ?? "None")")
    }
}

enum TransactionStep {
    case enterAmount
    case selectCategory
}
