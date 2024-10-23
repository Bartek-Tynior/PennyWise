//
//  DashboardViewModel.swift
//  PennyWise
//
//  Created by Bart Tynior on 22/10/2024.
//

import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var totalBudgeted: Double = 0.0
    @Published var totalLeft: Double = 0.0
    @Published var daysLeftInMonth: Int = 0

    func calculateBudget(categories: [Category], transactions: [Transaction]) {
        let (budgeted, left) = calculateTotalBudgetedAndLeft(categories: categories, transactions: transactions)
        self.totalBudgeted = budgeted
        self.totalLeft = left
    }

    func calculateDaysLeftInMonth() {
        let currentDate = Date()
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: currentDate) {
            let daysInMonth = range.count
            let today = calendar.component(.day, from: currentDate)
            daysLeftInMonth = daysInMonth - today
        }
    }

    private func calculateTotalBudgetedAndLeft(categories: [Category], transactions: [Transaction]) -> (Double, Double) {
        var totalBudgeted = 0.0
        var totalSpent = 0.0

        for category in categories {
            if category.periodicity == "Monthly" {
                totalBudgeted += category.allocatedAmount
                let categoryTransactions = transactions.filter { $0.categoryId == category.id }
                totalSpent += categoryTransactions.reduce(0.0) { $0 + $1.amount }
            }
        }

        let totalLeft = totalBudgeted - totalSpent
        return (totalBudgeted, totalLeft)
    }
}
