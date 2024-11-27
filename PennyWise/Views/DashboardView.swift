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
    @Binding var showCalendarModal: Bool

    let cornerRadius: CGFloat = 12
    
    @EnvironmentObject var appDataViewModel: AppDataViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var helperViewModel: HelperViewModel
    
    var body: some View {
        ZStack {
            // Main Dashboard Content
            VStack {
                TopNavBar(showModal: $showCalendarModal)
                
                // Monthly Section
                let monthlyCategories = appDataViewModel.categories.filter { $0.periodicity.caseInsensitiveCompare("monthly") == .orderedSame }
                
                if !monthlyCategories.isEmpty {
                    SectionView(
                        title: "Monthly",
                        daysLeft: helperViewModel.daysLeftInMonth,
                        totalBudgeted: helperViewModel.totalMonthlyBudgeted,
                        totalLeft: helperViewModel.totalMonthlyLeft,
                        categories: monthlyCategories,
                        helperViewModel: helperViewModel
                    )
                }
                
                // Weekly Section
                let weeklyCategories = appDataViewModel.categories.filter { $0.periodicity.caseInsensitiveCompare("weekly") == .orderedSame }
                
                if !weeklyCategories.isEmpty {
                    SectionView(
                        title: "Weekly",
                        daysLeft: helperViewModel.daysLeftInWeek,
                        totalBudgeted: helperViewModel.totalWeeklyBudgeted,
                        totalLeft: helperViewModel.totalWeeklyLeft,
                        categories: weeklyCategories,
                        helperViewModel: helperViewModel
                    )
                }
                
                // Add Category Button
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
                
                Spacer()
            }
            .padding(.horizontal)
            .onAppear {
                helperViewModel.calculateDaysLeftInMonth()
                helperViewModel.calculateDaysLeftInWeek()
                Task {
                    await loadData()
                }
            }
            
            // Floating Action Button (FAB)
            VStack {
                Spacer()
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
    
    func loadData() async {
        do {
            try await appDataViewModel.fetchAllData()
            helperViewModel.calculateBudget(categories: appDataViewModel.categories, transactions: appDataViewModel.transactions)
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

// Reusable Section View for Monthly and Weekly
struct SectionView: View {
    let title: String
    let daysLeft: Int
    let totalBudgeted: Double
    let totalLeft: Double
    let categories: [Category]
    let helperViewModel: HelperViewModel
    
    // Fixed width constant for the category column
    let categoryColumnWidth: CGFloat = 120
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack(spacing: 5) {
                VStack(alignment: .leading) {
                    Text(title)
                        .customFont(.regular, 16)
                        .foregroundColor(.gray)
                    Text("\(daysLeft) days left")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                                
                HStack(spacing: 5) {
                    VStack(alignment: .trailing) {
                        Text("Budgeted")
                            .customFont(.regular, 16)
                            .foregroundColor(.gray)
                        Text("$\(totalBudgeted, specifier: "%.2f")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .trailing) {
                        Text("Left")
                            .customFont(.regular, 16)
                            .foregroundColor(.gray)
                        Text("$\(totalLeft, specifier: "%.2f")")
                            .foregroundColor(totalLeft >= 0 ? .green : .red)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .padding(.bottom, 8)
            
            // Categories List
            VStack(spacing: 15) {
                ForEach(categories) { category in
                    let remainingBalance = helperViewModel.categoryBalances[category.id!] ?? category.allocatedAmount
                    
                    HStack(spacing: 5) {
                        HStack {
                            Text(category.emoji ?? "")
                            Text(category.name)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        HStack(spacing: 5) {
                            Text("$\(category.allocatedAmount, specifier: "%.2f")")
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("$\(remainingBalance, specifier: "%.2f")")
                                .foregroundColor(remainingBalance >= 0 ? .green : .red)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(remainingBalance >= 0 ? .green.opacity(0.2) : .red.opacity(0.2))
                                        .frame(width: textWidth(for: String(remainingBalance)))
                                )
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
            }
        }
        .padding(.vertical)
    }
    
    // Utility function for text width calculation
    func textWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 40
    }
}
