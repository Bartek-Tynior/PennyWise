//
//  Navbar.swift
//  PennyWise
//
//  Created by Bart Tynior on 10/10/2024.
//

import SwiftUI

struct TopNavBar: View {
    @State private var isShowingCategoryManagment = false
    @State private var isExpanded = false
    @State private var showModal = false
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text("Penny")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Wise.")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
            }
            
            Spacer()

            HStack(spacing: 10) {
                Button (action: {
                    showModal.toggle()
                }) {
                    Text("15 Jul - 22 Jul")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                }
                
                Button(action: {
                    isShowingCategoryManagment.toggle()
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.purple)
                        .frame(width: 24, height: 24)
                        .background(.purple.opacity(0.2))
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isShowingCategoryManagment) {
                    EditCategoriesView()
                }
            }
        }
        .padding()
        
        if showModal {
                        Modal(showModal: $showModal, title: "Access photos?", message: "This lets you choose which photos you want to add to this project.", buttonTitle: "Give Access") {
                            print("Pass to viewModel")
                        }
                    }
    }
}

#Preview {
    TopNavBar()
}
