//
//  AddTransactionFlowView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct AddTransactionFlowView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var transactionsViewModel = TransactionsViewModel()

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
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    private func saveTransaction() {
//        let newTransaction
//        
//        do {
//            transactionsViewModel.addTransaction()
//        }
    }
}

enum TransactionStep {
    case enterAmount
    case selectCategory
}
