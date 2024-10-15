//
//  AddCategoryView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import SwiftUI

struct AddCategoryView: View {
    @State private var categoryName: String = ""
    @State private var allocatedAmount: String = ""

    var body: some View {
        VStack(spacing: 20) {
            // Buttons at the top-right corner
            HStack(spacing: 10) {
                // Ellipsis Button
                Button(action: {
                    // Handle ellipsis action here
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Circle())
                }

                // Close Button
                Button(action: {
                    // Handle close action here
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                        .background(Color(UIColor.systemGray5))
                        .clipShape(Circle())
                }
            }
            .padding([.top, .trailing], 24)
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            
            // Category Icon
            Image(systemName: "cart.fill") // Replace with your category icon
                .resizable()
                .frame(width: 120, height: 120)
                .padding(.top, 50)
            
            // Input Fields
            VStack(alignment: .leading, spacing: 10) {
                Text("Category Name")
                    .font(.headline)
                
                TextField("Enter category name", text: $categoryName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                Text("Amount allocated")
                    .font(.headline)
                
                TextField("Enter amount", text: $allocatedAmount)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .keyboardType(.decimalPad) // Numeric keyboard for amount input
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Save Changes Button
            Button(action: {
                // Add save functionality
            }) {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 40)
        }
        .navigationBarTitle("Add Category", displayMode: .inline)
    }
}
