//
//  CategoryRowView.swift
//  PennyWise
//
//  Created by Bart Tynior on 28/10/2024.
//

import SwiftUI

struct CategoryRowView: View {
    @Binding var category: Category
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
