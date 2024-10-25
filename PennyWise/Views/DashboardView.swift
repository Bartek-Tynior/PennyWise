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

    let cornerRadius: CGFloat = 12

    @EnvironmentObject var appDataViewModel: AppDataViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var dashboardViewModel = DashboardViewModel()

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
                    ForEach(appDataViewModel.categories) { category in
                        let remainingBalance = dashboardViewModel.categoryBalances[category.id!] ?? category.allocatedAmount

                        HStack {
                            Text(category.name)
                            Spacer()
                            Text("$\(category.allocatedAmount, specifier: "%.2f")")
                            Spacer()
                            Text("$\(remainingBalance, specifier: "%.2f")")
                                .foregroundColor(remainingBalance >= 0 ? .green : .red)
                                .background(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .fill(remainingBalance >= 0 ? .green.opacity(0.2) : .red.opacity(0.2))
                                        .frame(width: textWidth(for: String(remainingBalance)))
                                )
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
                dashboardViewModel.calculateDaysLeftInMonth()
                if appDataViewModel.categories.isEmpty || appDataViewModel.transactions.isEmpty {
                    Task {
                        await loadData() // Ensure loadData is called
                    }
                } else {
                    // Call this if data is already loaded, otherwise it will happen after load
                    dashboardViewModel.calculateBudget(categories: appDataViewModel.categories, transactions: appDataViewModel.transactions)
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

    func loadData() async {
        do {
            // Fetch categories and transactions via the global AppDataViewModel
            try await appDataViewModel.fetchAllData()

            // Recalculate budget after data is fetched
            dashboardViewModel.calculateBudget(categories: appDataViewModel.categories, transactions: appDataViewModel.transactions)
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
