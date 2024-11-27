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
    @Binding var showModal: Bool

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text("Penny")
                    .customFont(.semiBold, 18)
                    .foregroundColor(.white)

                Text("Wise.")
                    .customFont(.semiBold, 18)
                    .foregroundColor(.purple)
            }

            Spacer()

            HStack(spacing: 10) {
                Button(action: {
                    showModal.toggle()
                }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.purple)
                        .frame(width: 30, height: 30)
                        .background(.purple.opacity(0.2))
                        .clipShape(Circle())
                }

                Button(action: {
                    isShowingCategoryManagment.toggle()
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.purple)
                        .frame(width: 30, height: 30)
                        .background(.purple.opacity(0.2))
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isShowingCategoryManagment) {
                    EditCategoriesView()
                }
            }
        }
        .padding()
    }
}
