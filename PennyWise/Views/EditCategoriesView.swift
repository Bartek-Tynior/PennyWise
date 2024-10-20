//
//  EditCategoriesView.swift
//  PennyWise
//
//  Created by Bart Tynior on 20/10/2024.
//

import SwiftUI

struct EditCategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var categoryName: String = ""
    @State var selectedTimeType: TimeTypes?
    
    enum TimeTypes: String, CaseIterable, Identifiable {
        case monthly, weekly
        var id: String { self.rawValue }
    }
    
    let categories = [
        ("Groceries", "Groceries", 45.78),
        ("Rent", "Rent", 90.73),
        ("Transport", "Transport", 93.21)
    ]
    
    // Extract the button for each item into a separate view
    func categoryItem(category: (String, String, Double)) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                Circle()
                    .fill(Color.purple)
                    .frame(maxWidth: 50)
                    .overlay(
                        Text("B")
                            .font(.title)
                            .foregroundColor(.white)
                    )
                
                TextField("Category name", text: $categoryName, prompt: Text("Your email").foregroundStyle(.white))
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            
            HStack(spacing: 0) {
                TextField("Category name", text: $categoryName, prompt: Text("Your email").foregroundStyle(.white))
                    .font(.headline)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                VStack {
                    CustomPicker(selection: self.$selectedTimeType) {
                        TimeTypes.allCases
                    }
                }
                
                Button(action: {
                    // Handle Action
                }) {
                    Circle()
                        .fill(.red.opacity(0.2))
                        .frame(maxWidth: 50)
                        .overlay(
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        )
                }
            }
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Edit all categories")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    // Handle Action
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Edit")
                        .foregroundStyle(.purple)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 12).fill(.purple.opacity(0.2)))
                }
            }
            .padding()
            
            ScrollView {
                ForEach(categories, id: \.0) { category in
                    categoryItem(category: category)
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

#Preview {
    EditCategoriesView()
        .preferredColorScheme(.dark)
}
