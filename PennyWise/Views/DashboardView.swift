//
//  DashboardView.swift
//  PennyWise
//
//  Created by Bart Tynior on 09/10/2024.
//

import SwiftUI

struct DashboardView: View {
    @State private var isShowingCategory = false
    @State private var isShowingTransaction = false

    @StateObject private var categoryViewModel = CategoryViewModel()

    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            TopNavBar()
            
            // Monthly Overview
            HStack {
                VStack(alignment: .leading) {
                    Text("Monthly")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Text("12 days left")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Budgeted")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Text("$300")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Left")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Text("$279")
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(.gray.opacity(0.2))
            .cornerRadius(10)
            .padding()
            
            // List of Categories
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(categoryViewModel.categories, id: \.self) { category in // Use \.self if id is optional
                        HStack {
                            //                            Image(category.iconName)
                            //                                .resizable()
                            //                                .scaledToFit()
                            //                                .frame(width: 34)
                            
                            Text(category.name)
                            
                            Spacer()
                            
                            Text("$\(category.budget, specifier: "%.2f")")
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: textWidth(for: String(format: "%.2f", category.remaining)))
                                .overlay {
                                    Text("$\(category.remaining, specifier: "%.2f")")
                                        .foregroundColor(.green)
                                }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                    
                    Button(action: {
                        isShowingCategory.toggle()
                    }) {
                        Text("Add new category")
                            .foregroundColor(.purple)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.1)))
                    .sheet(isPresented: $isShowingCategory) {
                        AddCategoryView()
                    }
                }
            }
            .padding(.horizontal)
            .task {
                try? await categoryViewModel.fetchCategories() // Use the instance, not the type
            }
        }
        
        // Floating Action Button (FAB)
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    isShowingTransaction.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black.opacity(0.9))
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                .sheet(isPresented: $isShowingTransaction) {
                    AddTransactionFlowView()
                }
            }
        }
    }
    
    // Function to calculate the width based on text
    func textWidth(for text: String) -> CGFloat {
        // Dynamically calculate width based on text content
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 40
    }
}
