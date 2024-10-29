//
//  TransactionsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import SwiftUI

struct TransactionsView: View {
    @State private var selectedTab: String = "All" // Updated default to "All"
    @State private var isShowingTransaction = false

    @StateObject private var appDataViewModel = AppDataViewModel()

    // Filtered transactions based on the selected tab
    var filteredTransactions: [Transaction] {
        switch selectedTab {
        case "All Month":
            return appDataViewModel.transactions.filter { transaction in
                Calendar.current.isDate(transaction.createdAt, equalTo: Date(), toGranularity: .month)
            }
        case "This Week":
            return appDataViewModel.transactions.filter { transaction in
                Calendar.current.isDate(transaction.createdAt, equalTo: Date(), toGranularity: .weekOfYear)
            }
        default: // "All"
            return appDataViewModel.transactions
        }
    }

    // Group filtered transactions by date
    var groupedTransactions: [String: [Transaction]] {
        Dictionary(grouping: filteredTransactions) { transaction in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            return dateFormatter.string(from: transaction.createdAt)
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
                TabButton(title: "All", selectedTab: $selectedTab)
                TabButton(title: "All Month", selectedTab: $selectedTab)
                TabButton(title: "This Week", selectedTab: $selectedTab)

                Spacer()
            }
            .padding()

            // Transactions List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(groupedTransactions.keys.sorted(by: >), id: \.self) { date in
                        // Section for each date
                        VStack(alignment: .leading, spacing: 8) {
                            Text(date) // Date header, e.g., "28 October"
                                .font(.headline)
                                .padding(.leading)
                                .padding(.top)

                            ForEach(groupedTransactions[date]!) { transaction in
                                HStack {
                                    // Optional icon for category (replace with actual category icon if available)
                                    Image(systemName: "cart.fill")
                                        .foregroundColor(.purple)
                                    
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
                                .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .task {
                do {
                    try await appDataViewModel.fetchAllData()
                } catch {
                    print("Error fetching transactions: \(error)")
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
