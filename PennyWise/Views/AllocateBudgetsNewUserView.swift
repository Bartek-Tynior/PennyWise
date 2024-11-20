//
//  AllocateBudgetsNewUserView.swift
//  PennyWise
//
//  Created by Bart Tynior on 29/10/2024.
//

import SwiftUI

struct AllocateBudgetsNewUserView: View {
    @Binding var selectedCategories: [CategoryRecommendation]
    @State private var isLoading = false
    @State private var errorMessage: String?
    var onAddCategories: () -> Void
    var onPrevious: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            headerView

            ScrollView {
                if isLoading {
                    ProgressView("Loading categories...")
                } else {
                    ForEach($selectedCategories) { $category in
                        CategoryRowSetupView(category: $category)
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)

        // Floating Action Button (FAB)
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    onPrevious()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.purple)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)
            }
        }
    }

    private var headerView: some View {
        HStack {
            Text("Edit all categories")
                .font(.title)
                .bold()
            Spacer()
            Button("Save") {
                onAddCategories()
            }
            .foregroundStyle(.purple)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 12).fill(.purple.opacity(0.2)))
        }
        .padding()
    }
}

struct CategoryRowSetupView: View {
    @Binding var category: CategoryRecommendation
    @State private var selectedPeriodicity: Periodicity?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 50)
                    .overlay(Text("B").font(.title).foregroundColor(.white))

                TextField("Category name", text: $category.name)
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundStyle(.white)
            }

            HStack(spacing: 10) {
                TextField("Allocated Amount", value: $category.allocatedAmount, format: .number)
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundStyle(.white)

                CustomPicker(selection: Binding(
                    get: { selectedPeriodicity ?? category.periodicityEnum },
                    set: { newValue in
                        selectedPeriodicity = newValue
                        if let newValue = newValue {
                            category.periodicityEnum = newValue
                        }
                    }
                )) {
                    Periodicity.allCases
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        .onAppear {
            // Initialize selectedPeriodicity with the current category periodicity
            selectedPeriodicity = category.periodicityEnum
        }
    }
}
