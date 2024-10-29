//
//  TransactionsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import SwiftUI

struct TransactionsView: View {
    @State private var selectedTab: String = "All Month"
    @State private var isShowingTransaction = false

    @StateObject private var appDataViewModel = AppDataViewModel()

    // Group transactions by date
    var groupedTransactions: [String: [Transaction]] {
        Dictionary(grouping: appDataViewModel.transactions) { transaction in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM"
            return dateFormatter.string(from: transaction.createdAt) // Format as "28 October"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Transactions")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            // Tabs for All Month and This Week
            HStack {
                Button(action: {
                    selectedTab = "All Month"
                }) {
                    Text("All Month")
                        .fontWeight(selectedTab == "All Month" ? .bold : .semibold)
                        .foregroundColor(selectedTab == "All Month" ? .purple : .gray)
                        .padding()
                }
                .background(selectedTab == "All Month" ? Color.purple.opacity(0.2) : Color.clear)
                .cornerRadius(10)

                Button(action: {
                    selectedTab = "This Week"
                }) {
                    Text("This Week")
                        .fontWeight(selectedTab == "This Week" ? .bold : .semibold)
                        .foregroundColor(selectedTab == "This Week" ? .purple : .gray)
                        .padding()
                }
                .background(selectedTab == "This Week" ? Color.purple.opacity(0.2) : Color.clear)
                .cornerRadius(10)

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
