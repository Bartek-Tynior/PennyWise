//
//  SignInView.swift
//  PennyWise
//
//  Created by Bart Tynior on 08/10/2024.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Spacer()
            
            TopNavBar()
                .padding(.bottom, 40)
            
            TextField("Email", text: $authViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
            
            Text("Use at least 6 characters including a number and a symbol.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Spacer()
            
            VStack(spacing: 10) {
                Button(action: {
                    Task {
                        try await authViewModel.signIn()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)

                Button(action: {
                    // Handle Apple sign in logic here
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Sign in with Apple")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
