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
    @StateObject private var transactionViewModel = TransactionsViewModel()
    @StateObject private var dashboardViewModel = DashboardViewModel()

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
                    Text("\(dashboardViewModel.daysLeftInMonth) days left")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Budgeted")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Text("$\(dashboardViewModel.totalBudgeted, specifier: "%.2f")")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Left")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Text("$\(dashboardViewModel.totalLeft, specifier: "%.2f")")
                        .foregroundColor(dashboardViewModel.totalLeft >= 0 ? .green : .red)
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
                    ForEach(categoryViewModel.categories) { category in
                        HStack {
                            Text(category.name)
                            
                            Spacer()
                            
                            Text("$\(category.allocatedAmount, specifier: "%.2f")")
                            
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.green.opacity(0.2))
                                .frame(width: textWidth(for: String(format: "%.2f", category.allocatedAmount)))
                                .overlay {
                                    Text("$\(category.allocatedAmount, specifier: "%.2f")")
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
            .onAppear {
                if categoryViewModel.categories.isEmpty || transactionViewModel.transactions.isEmpty {
                    Task {
                        await loadData()
                    }
                }
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
    
    // Function to load data and update the dashboard view model
    func loadData() async {
        do {
            // Fetch categories and transactions
            try await categoryViewModel.fetchCategories()
            try await transactionViewModel.fetchTransactions()
            
            // Update the dashboard view model with fetched data
            dashboardViewModel.calculateBudget(
                categories: categoryViewModel.categories,
                transactions: transactionViewModel.transactions
            )
            
            dashboardViewModel.calculateDaysLeftInMonth()
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    // Function to calculate the width based on text
    func textWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 40
    }
}

