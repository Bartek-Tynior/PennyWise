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
            
            Spacer()

            VStack(alignment: .leading, spacing: 40) {
                Text("Welcome to PennyWise 👋")
                    .foregroundStyle(.gray)
                    .font(.title)
                    .multilineTextAlignment(.center)

                Text("A simple & beautiful budgeting app designed to help you curb spending.")
                    .foregroundStyle(.gray)
                    .font(.title2)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()

            VStack(spacing: 10) {
                Button(action: {
                    isShowingSignUp.toggle()
                }) {
                    Text("Create Account")
                        .bold()
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
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                }
                .sheet(isPresented: $isShowingSignIn) {
                    SignInView()
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
