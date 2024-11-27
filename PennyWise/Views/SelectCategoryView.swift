//
//  SelectCategoryView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct SelectCategoryView: View {
    @Binding var selectedAmount: String
    @Binding var selectedCategoryId: String?
    @Binding var transactionDescription: String
    var onAddTransaction: () -> Void
    
    @EnvironmentObject var appDataViewModel: AppDataViewModel
    
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
                
                Text("$\(selectedAmount)")
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
            
            // Use categories from the view model
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(appDataViewModel.categories, id: \.id) { category in
                        CategoryRow(category: category, isSelected: selectedCategoryId == category.id?.uuidString)
                            .onTapGesture {
                                selectedCategoryId = category.id?.uuidString
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
                    .background(selectedCategoryId != nil ? Color.purple : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .disabled(selectedCategoryId == nil)
        }
        .padding(.vertical)
    }
}

struct CategoryRow: View {
    let category: Category // Accept Category model
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(category.emoji ?? "")
            
            Text(category.name) // Display category name
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

