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
    
    @State var selectedTimeType: TimeTypes?
    
    // State variables for handling ActionSheet and Delete Confirmation
    @State private var showActionSheet = false
    @State private var showDeleteConfirmation = false
    
    enum TimeTypes: String, CaseIterable, Identifiable {
        case monthly, weekly
        var id: String { self.rawValue }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                // Buttons at the top-right corner
                HStack(spacing: 10) {
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
                Image("Groceries")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .padding(.top, 50)
                
                // Input Fields
                VStack(alignment: .leading, spacing: 10) {
                    Text("Category Name")
                        .font(.headline)
                    
                    TextField("Email", text: self.$categoryName, prompt: Text("Enter category name")
                        .foregroundStyle(.gray))
                        .font(.headline)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    
                    Text("Amount allocated")
                        .font(.headline)
                    
                    HStack {
                        TextField("Email", text: self.$allocatedAmount, prompt: Text("Enter your budget")
                            .foregroundStyle(.gray))
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
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Save Changes Button
                Button(action: {
                    // Add save functionality
                }) {
                    Text("Create a category")
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
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

#Preview {
    AddCategoryView()
}
