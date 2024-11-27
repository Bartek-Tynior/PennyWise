//
//  SelectCategoriesNewUserView.swift
//  PennyWise
//
//  Created by Bart Tynior on 29/10/2024.
//

import SwiftUI

struct SelectCategoriesNewUserView: View {
    @Binding var selectedCategories: [CategoryRecommendation]
    var onContinue: () -> Void

    // Sample categories
    private var foodCategories: [CategoryRecommendation] {
        [
            CategoryRecommendation(name: "Groceries", allocatedAmount: 0, emoji: "😀", periodicity: Periodicity.monthly.rawValue)
        ]
    }

    private var transportationCategories: [CategoryRecommendation] {
        [
            CategoryRecommendation(name: "Uber/Lyft", allocatedAmount: 0, emoji: "😀", periodicity: Periodicity.monthly.rawValue)
        ]
    }

    private var entertainmentCategories: [CategoryRecommendation] {
        [
            CategoryRecommendation(name: "Going Out", allocatedAmount: 0, emoji: "😀", periodicity: Periodicity.monthly.rawValue)
        ]
    }

    var body: some View {
        VStack {
            Text("Let's create some categories")
                .font(.headline)
                .padding()

            ScrollView {
                VStack(spacing: 10) {
                    // Combining all categories and displaying them
                    ForEach(transportationCategories + foodCategories + entertainmentCategories, id: \.name) { category in
                        CategoryRowRecommendation(
                            category: category,
                            isSelected: selectedCategories.contains { $0.name == category.name } // Check if category is selected by name
                        )
                        .onTapGesture {
                            toggleCategorySelection(category)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            
            Spacer()
            
            Button(action: onContinue) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
        }
    }
    
    // Toggle the selection of the category by name
    private func toggleCategorySelection(_ category: CategoryRecommendation) {
        if let index = selectedCategories.firstIndex(where: { $0.name == category.name }) {
            selectedCategories.remove(at: index) // Deselect if already selected
        } else {
            selectedCategories.append(category) // Add if not selected
        }
    }
}

struct CategoryRowRecommendation: View {
    let category: CategoryRecommendation
    var isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: "folder") // Placeholder; replace with category icon if available
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text(category.name)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            // Checkmark based on selection state
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .imageScale(.large)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.gray)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
