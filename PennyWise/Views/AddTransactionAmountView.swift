//
//  AddTransactionAmountView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct AddTransactionAmountView: View {
    @Binding var amount: String
        var onContinue: () -> Void
        
        var body: some View {
            VStack {
                Spacer()
                
                // Displaying entered amount
                Text("$\(amount.isEmpty ? "0.00" : amount)")
                    .font(.system(size: 50))
                    .foregroundColor(.purple)
                    .padding(.bottom, 40)
                
                // Custom number pad
                VStack(spacing: 10) {
                    ForEach([["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"], [".", "0", "⌫"]], id: \.self) { row in
                        HStack {
                            ForEach(row, id: \.self) { item in
                                Button(action: {
                                    handleButtonPress(item)
                                }) {
                                    Text(item)
                                        .font(.system(size: 28))
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.black)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(40)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    // Move to the next step
                    onContinue()
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
            }
        }
        
        private func handleButtonPress(_ item: String) {
            if item == "⌫" {
                amount = String(amount.dropLast())
            } else if item == "." && !amount.contains(".") {
                amount += item
            } else if item != "." && amount.count < 10 {
                amount += item
            }
        }
}
