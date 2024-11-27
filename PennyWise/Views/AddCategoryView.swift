//
//  AddCategoryView.swift
//  PennyWise
//
//  Created by Bart Tynior on 14/10/2024.
//

import MCEmojiPicker
import SwiftUI

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appDataViewModel: AppDataViewModel
    @State private var categoryName: String = ""
    @State private var allocatedAmount: String = ""
    @State private var selectedEmoji: String = "🙂" // Default emoji
    @State private var selectedPeriodicity: Periodicity?
    @State private var showEmojiPicker = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Close and Create Buttons
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Close the view
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding()
                                
                // Emoji Picker
                Button(action: {
                    showEmojiPicker.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                                        
                        Text(selectedEmoji)
                            .font(.system(size: 50))
                                        
                        Image(systemName: "pencil")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Circle().fill(Color.purple))
                            .offset(x: 30, y: 30)
                    }
                }
                .emojiPicker(
                    isPresented: $showEmojiPicker,
                    selectedEmoji: $selectedEmoji
                )
                                
                // Input Fields
                VStack(alignment: .leading, spacing: 10) {
                    Text("Category Name")
                        .font(.headline)
                    
                    TextField("Enter category name", text: $categoryName)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    Text("Amount Allocated")
                        .font(.headline)
                    
                    HStack {
                        TextField("Enter amount", text: $allocatedAmount)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        
                        CustomPicker(selection: $selectedPeriodicity) {
                            Periodicity.allCases
                        }
                    }
                }
                .padding()
                
                Spacer()
                                
                Button(action: {
                    Task {
                        saveCategory()
                    }
                }) {
                    Text("Create a Category")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    func saveCategory() {
        guard let userId = SupabaseService.shared.getClient().auth.currentUser?.id else {
            print("Invalid input for transaction or user not logged in")
            return
        }
            
        let category = Category(
            id: UUID(),
            name: categoryName,
            allocatedAmount: Double(allocatedAmount)!,
            periodicity: selectedPeriodicity!.rawValue,
            emoji: selectedEmoji,
            createdAt: Date(),
            userId: userId
        )
            
        Task {
            try? await appDataViewModel.addCategory(category)
        }
    }
}
