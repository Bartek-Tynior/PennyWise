//
//  TransactionsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//
import SwiftUI

struct TransactionsView: View {
    @State private var selectedTab: String = "All Month"
        
    var body: some View {
        VStack {
            // Transactions Header
            HStack {
                Text("Transactions")
                    .font(.title)
                    .bold()
                    .padding(.leading)
                    
                Spacer()
            }
                
            // Tabs for All Month and This Week
            HStack {
                Button(action: {
                    selectedTab = "All Month"
                }) {
                    Text("All Month")
                        .fontWeight(selectedTab == "All Month" ? .bold : .regular)
                        .foregroundColor(selectedTab == "All Month" ? .purple : .gray)
                        .padding()
                }
                .background(selectedTab == "All Month" ? Color.purple.opacity(0.2) : Color.clear)
                .cornerRadius(10)
                    
                Button(action: {
                    selectedTab = "This Week"
                }) {
                    Text("This Week")
                        .fontWeight(selectedTab == "This Week" ? .bold : .regular)
                        .foregroundColor(selectedTab == "This Week" ? .purple : .gray)
                        .padding()
                }
                .background(selectedTab == "This Week" ? Color.purple.opacity(0.2) : Color.clear)
                .cornerRadius(10)
                    
                Spacer()
            }
            .padding(.horizontal)
                
            // Transactions List
            ScrollView {
                VStack(spacing: 15) {
                    TransactionRow(category: "Groceries", amount: 45.30)
                    TransactionRow(category: "Groceries", amount: 54.75)
                }
            }
            .padding(.horizontal)
                

            // Floating Action Button (FAB)
            ZStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // Handle action
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .background(Color.purple)
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            
        }
        .navigationBarTitle("Transactions", displayMode: .inline)
    }
}

struct TransactionRow: View {
    var category: String
    var amount: Double
        
    var body: some View {
        HStack {
            Image(systemName: "cart.fill")
                .resizable()
                .frame(width: 20)
                            
            Text(category)
                            
            Spacer()
                            
            Text("$\(amount)")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
}
