//
//  SelectCategoryView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct SelectCategoryView: View {
    @Binding var selectedCategory: String?
        var onAddTransaction: () -> Void
        
        let categories = [
            ("Groceries", "cart.fill", Color.purple),
            ("Rent", "house.fill", Color.green),
            ("Transport", "car.fill", Color.blue)
        ]
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("Choose Category")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 20)
                
                // Category selection grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(categories, id: \.0) { category in
                        Button(action: {
                            selectedCategory = category.0
                        }) {
                            VStack {
                                Image(systemName: category.1)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .padding()
                                    .background(selectedCategory == category.0 ? category.2 : Color.gray.opacity(0.2))
                                    .cornerRadius(12)
                                
                                Text(category.0)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Add Transaction Button
                Button(action: {
                    // Handle adding the transaction
                    onAddTransaction()
                }) {
                    Text("Add Transaction")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(selectedCategory == nil)
            }
        }
}
