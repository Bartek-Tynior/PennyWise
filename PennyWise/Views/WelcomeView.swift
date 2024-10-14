//
//  WelcomeView.swift
//  PennyWise
//
//  Created by Bart Tynior on 10/10/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var isShowingSignUp = false
    @State private var isShowingSignIn = false

    var body: some View {
        VStack {
            TopNavBar()
            
            Spacer()

            VStack(spacing: 40) {
                Text("Welcome to PennyWise 👋")
                    .font(.title)
                    .multilineTextAlignment(.center)

                Text("A simple & beautiful budgeting app designed to help you curb spending.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()

            VStack(spacing: 10) {
                Button(action: {
                    isShowingSignUp.toggle()
                }) {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .sheet(isPresented: $isShowingSignUp) {
                    SignUpView()
                }

                Button(action: {
                    isShowingSignIn.toggle()
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(30)
                }
                .sheet(isPresented: $isShowingSignIn) {
                    SignInView()
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                TopNavBar() // Logo in the navigation bar
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
