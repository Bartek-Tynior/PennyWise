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

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isExpanded = false

    var body: some View {
        VStack {
            HStack {
                Text("15 Jul - 22 Jul")
                    .font(.headline)
                    .foregroundColor(.purple)
                Image(systemName: "chevron.down")
            }
            .onTapGesture {
                // Animation to expand the date picker
                withAnimation {
                    isExpanded.toggle()
                }
            }
                        
            if isExpanded {
                // Placeholder for date picker dropdown or expanded date view
                Text("Date picker placeholder").transition(.move(edge: .top))
            }
            
            // Monthly Overview
            HStack {
                VStack(alignment: .leading) {
                    Text("Monthly")
                        .font(.headline)
                    Text("12 days left")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack {
                    Text("Budgeted")
                        .font(.headline)
                    Text("$300")
                }
                Spacer()
                VStack {
                    Text("Left")
                        .font(.headline)
                    Text("$279")
                        .foregroundColor(.green)
                }
            }
            .padding()
            
            // List of Categories
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(sampleCategories) { category in
                        HStack {
                            Image(systemName: category.iconName)
                                .resizable()
                                .frame(width: 20)
                                            
                            Text(category.name)
                                            
                            Spacer()
                                            
                            Text("$\(category.budget)")
                                            
                            Spacer()
                                            
                            Text("$\(category.remaining)")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    }
                    
                    Button(action: {
                        isShowingCategory.toggle()
                    }) {
                        Text("Add new category")
                            .foregroundColor(.purple)
                    }
                    .padding()
                    .sheet(isPresented: $isShowingCategory) {
                        AddCategoryView()
                    }
                }
            }
            .padding()
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
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(Circle())
                        .shadow(color: .gray.opacity(0.4), radius: 4, x: 2, y: 2)
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

let sampleCategories = [
    Category(name: "Groceries", iconName: "cart.fill", budget: 60, remaining: 27),
    Category(name: "Rent", iconName: "house.fill", budget: 37, remaining: 27),
    Category(name: "Transport", iconName: "car.fill", budget: 60, remaining: 27)
]
