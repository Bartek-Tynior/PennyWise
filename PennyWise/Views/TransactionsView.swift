//
//  TransactionsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import SwiftUI

struct TransactionsView: View {
    @EnvironmentObject private var appDataViewModel: AppDataViewModel
    @State private var selectedTab: String = "All"
    @State private var isShowingTransaction = false

    // Filtered transactions based on the selected tab
    var filteredTransactions: [Transaction] {
        let today = Date()
        switch selectedTab {
        case "All Month":
            return appDataViewModel.transactions.filter {
                Calendar.current.isDate($0.createdAt, equalTo: today, toGranularity: .month)
            }
        case "This Week":
            return appDataViewModel.transactions.filter {
                Calendar.current.isDate($0.createdAt, equalTo: today, toGranularity: .weekOfYear)
            }
        default: // "All"
            return appDataViewModel.transactions
        }
    }

    // Group filtered transactions by date
    var groupedTransactions: [String: [Transaction]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return Dictionary(grouping: filteredTransactions) {
            formatter.string(from: $0.createdAt)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Transactions")
                .font(.title)
                .bold()
                .padding(.horizontal)

            // Tabs for All, All Month, and This Week
            HStack {
                ForEach(["All", "All Month", "This Week"], id: \.self) { tab in
                    TabButton(title: tab, selectedTab: $selectedTab)
                }
                Spacer()
            }
            .padding()

            // Transactions List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(date)
                                .font(.headline)
                                .padding(.leading)
                                .padding(.top)

                            ForEach(groupedTransactions[date]!) { transaction in
                                HStack {
                                    
                                    Text(appDataViewModel.categories.first(where: { $0.id == transaction.categoryId })?.emoji ?? "")
                                    
                                    VStack(alignment: .leading) {
                                        Text(transaction.description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Text("$\(transaction.amount, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)

            // Floating Action Button (FAB)
            ZStack {
                HStack {
                    Spacer()
                    Button(action: { isShowingTransaction.toggle() }) {
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
                            .environmentObject(appDataViewModel) // Pass environment object
                    }
                }
            }
        }
        .task {
            do {
                try await appDataViewModel.fetchAllData()
            } catch {
                print("Error fetching transactions: \(error)")
            }
        }
    }
}

// Custom button view for tabs
struct TabButton: View {
    let title: String
    @Binding var selectedTab: String

    var body: some View {
        Button(action: {
            selectedTab = title
        }) {
            Text(title)
                .fontWeight(selectedTab == title ? .bold : .semibold)
                .foregroundColor(selectedTab == title ? .purple : .gray)
                .padding()
                .background(selectedTab == title ? Color.purple.opacity(0.2) : Color.clear)
                .cornerRadius(10)
        }
    }
}
