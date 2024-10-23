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
                    ForEach(appDataViewModel.transactions) { transaction in
                        HStack {
                            Text(transaction.description)
                                            
                            Spacer()
                                            
                            Text("$\(transaction.amount, specifier: "%.2f")")
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal)
            .task {
                do {
                    try await appDataViewModel.fetchAllData()
                } catch {
                    // Handle error here, if necessary
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
