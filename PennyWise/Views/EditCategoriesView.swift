//
//  EditCategoriesView.swift
//  PennyWise
//
//  Created by Bart Tynior on 20/10/2024.
//

import SwiftUI

struct EditCategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var appDataViewModel = AppDataViewModel()
    
    // Track edits in a temporary array
    @State private var editedCategories: [Category] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading) {
            headerView
            
            ScrollView {
                if isLoading {
                    ProgressView("Loading categories...")
                } else {
                    ForEach($editedCategories) { $category in
                        CategoryRowView(category: $category)
                    }
                }
            }
            .padding()
            .task {
                Task {
                    await loadCategories() // Ensure loadData is called
                }
            }
            .alert("Error", isPresented: .constant(errorMessage != nil), presenting: errorMessage) { _ in
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: { errorMessage in
                Text(errorMessage)
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
    
    private var headerView: some View {
        HStack {
            Text("Edit all categories")
                .font(.title)
                .bold()
            Spacer()
            Button("Edit") {
                Task { await commitChanges() }
            }
            .foregroundStyle(.purple)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 12).fill(.purple.opacity(0.2)))
        }
        .padding()
    }
    
    private func loadCategories() async {
            isLoading = true
            do {
                try await appDataViewModel.fetchAllData()
                editedCategories = appDataViewModel.categories // Copy categories for editing
            } catch {
                errorMessage = "Error fetching categories: \(error.localizedDescription)"
            }
            isLoading = false
        }
        
        private func commitChanges() async {
            isLoading = true
            do {
                try await appDataViewModel.updateCategories(editedCategories) // Update categories in bulk
                
                // Dismiss EditCategoriesView
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorMessage = "Error updating categories: \(error.localizedDescription)"
            }
            isLoading = false
        }
}

#Preview {
    EditCategoriesView()
        .preferredColorScheme(.dark)
}
