//
//  HelperViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 28/10/2024.
//

import Combine
import Foundation

class HelperViewModel: ObservableObject {
    // Published properties for monthly data
    @Published var totalMonthlyBudgeted: Double = 0.0
    @Published var totalMonthlyLeft: Double = 0.0
    @Published var daysLeftInMonth: Int = 0
    
    // Published properties for weekly data
    @Published var totalWeeklyBudgeted: Double = 0.0
    @Published var totalWeeklyLeft: Double = 0.0
    @Published var daysLeftInWeek: Int = 0
    
    @Published var categoryBalances: [UUID: Double] = [:]

    // Calculate balances by periodicity
    func calculateCategoryBalances(categories: [Category], transactions: [Transaction]) {
        var balances = [UUID: Double]()
        
        for category in categories {
            let categoryTransactions = transactions.filter { $0.categoryId == category.id }
            let totalSpent = categoryTransactions.reduce(0.0) { $0 + $1.amount }
            let remainingBalance = category.allocatedAmount - totalSpent
            balances[category.id!] = remainingBalance
        }
        
        categoryBalances = balances
    }
    
    // Calculate budgets based on periodicity and update totals
    func calculateBudget(categories: [Category], transactions: [Transaction]) {
        let (monthlyBudgeted, monthlyLeft) = calculateTotalBudgetedAndLeft(
            categories: categories,
            transactions: transactions,
            periodicity: "monthly"
        )
        totalMonthlyBudgeted = monthlyBudgeted
        totalMonthlyLeft = monthlyLeft
        
        let (weeklyBudgeted, weeklyLeft) = calculateTotalBudgetedAndLeft(
            categories: categories,
            transactions: transactions,
            periodicity: "weekly"
        )
        totalWeeklyBudgeted = weeklyBudgeted
        totalWeeklyLeft = weeklyLeft
        
        // Update category balances
        calculateCategoryBalances(categories: categories, transactions: transactions)
    }
    
    // Calculate remaining days in the month
    func calculateDaysLeftInMonth() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: currentDate) {
            let daysInMonth = range.count
            let today = calendar.component(.day, from: currentDate)
            daysLeftInMonth = daysInMonth - today
        }
    }
    
    // Calculate remaining days in the week
    func calculateDaysLeftInWeek() {
        let calendar = Calendar.current
        let currentDate = Date()
        if let endOfWeek = calendar.nextWeekend(startingAfter: currentDate)?.end {
            let daysRemaining = calendar.dateComponents([.day], from: currentDate, to: endOfWeek).day ?? 0
            daysLeftInWeek = daysRemaining
        } else {
            daysLeftInWeek = 0
        }
    }

    // Private method to calculate budgeted and left amounts by periodicity
    private func calculateTotalBudgetedAndLeft(categories: [Category], transactions: [Transaction], periodicity: String) -> (Double, Double) {
        var totalBudgeted = 0.0
        var totalSpent = 0.0

        for category in categories {
            if category.periodicity.caseInsensitiveCompare(periodicity) == .orderedSame {
                totalBudgeted += category.allocatedAmount
                let categoryTransactions = transactions.filter { $0.categoryId == category.id }
                totalSpent += categoryTransactions.reduce(0.0) { $0 + $1.amount }
            }
        }

        let totalLeft = totalBudgeted - totalSpent
        return (totalBudgeted, totalLeft)
    }
}
