//
//  SignUpView.swift
//  PennyWise
//
//  Created by Bart Tynior on 10/10/2024.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                Text("Penny")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Wise.")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
            }
            
            TextField("Name", text: $authViewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
            
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
                        try await authViewModel.signUp()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Sign Up")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    // Handle Apple sign up logic here
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Sign up with Apple")
                    }
                    .bold()
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
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
