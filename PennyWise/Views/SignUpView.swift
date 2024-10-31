//
//  SignUpView.swift
//  PennyWise
//
//  Created by Bart Tynior on 10/10/2024.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    var onContinue: () -> Void

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
            .padding(.bottom, 40)
            
            TextField("Name", text: $authViewModel.name, prompt: Text("Your name").foregroundStyle(.gray))
                .font(.headline)
                .padding()
                .foregroundStyle(.white)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            TextField("Email", text: $authViewModel.email, prompt: Text("Your email").foregroundStyle(.gray))
                .font(.headline)
                .padding()
                .foregroundStyle(.white)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("Password", text: $authViewModel.password, prompt: Text("Your password").foregroundStyle(.gray))
                .font(.headline)
                .padding()
                .foregroundStyle(.white)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Text("Use at least 6 characters including a number and a symbol.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.vertical, 10)
            
            Spacer()
            
            VStack(spacing: 10) {
                Button(action: {
                    onContinue()
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
