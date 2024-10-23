//
//  SelectCategoryView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct SelectCategoryView: View {
    @Binding var selectedCategory: String?
    @Binding var transactionDescription: String // Added description binding
    var onAddTransaction: () -> Void
    
    let categories = [
        ("Groceries", "Groceries", Color.purple),
        ("Rent", "Rent", Color.green),
        ("Transport", "Transport", Color.blue)
    ]
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    // Optionally handle back navigation
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
                
                Text("$\(selectedCategory ?? "0.00")") // Ensure you display the right value here
                    .font(.headline)
                    .bold()
                
                Spacer()
            }
            .padding()
            
            // Transaction Description
            Section {
                TextField("For", text: $transactionDescription)
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
            } header: {
                Text("Specify Transaction")
                    .font(.title2)
                    .bold()
                    .padding(.vertical)
            }
            
            Spacer()
            
            // Category Selection
            Text("Choose Category")
                .font(.title2)
                .bold()
                .padding(.vertical)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(categories, id: \.0) { category in
                        CategoryRow(category: category, isSelected: selectedCategory == category.0)
                            .onTapGesture {
                                selectedCategory = category.0
                            }
                            .padding(.horizontal)
                    }
                }
            }
            
            Spacer()
            
            // Add Transaction Button
            Button(action: {
                // Handle adding the transaction
                onAddTransaction()
            }) {
                Text("Add Transaction")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedCategory != nil ? Color.purple : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(selectedCategory == nil)
        }
        .padding(.vertical)
    }
}

// Category Row Component
struct CategoryRow: View {
    let category: (String, String, Color)
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Image(category.1)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text(category.1)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

