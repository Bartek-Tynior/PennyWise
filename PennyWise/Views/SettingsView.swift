//
//  SettingsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var selectedCurrency: Currency? = .usd
    @State private var reminderActivation: Bool = false
    @State private var showChangePasswordSheet = false
    @State private var showChangePassword = false
    @State private var isSubscriptionActive = true
    @State private var subscriptionExpirationDate = "30 October 2024"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.title)
                .bold()
                .padding(.horizontal)
                
            ScrollView {
                Circle()
                    .fill(Color.purple)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Text(name.prefix(1).uppercased()) // Display the first letter of the name
                            .font(.title)
                            .foregroundColor(.white)
                    )
                    .padding(.vertical, 10)
                    
                VStack(alignment: .leading, spacing: 10) {
                    Section {
                        TextField("Name", text: $name)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                        TextField("Email", text: $email)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        Button {
                            showChangePasswordSheet = true
                        } label: {
                            Text("Change Password")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                        .sheet(isPresented: $showChangePasswordSheet) {
                            ChangePasswordView(showSheet: $showChangePasswordSheet)
                        }
                    } header: {
                        Text("Account Settings")
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                    }
                        
                    Section {
                        CustomPicker(selection: $selectedCurrency) {
                            Currency.allCases
                        }
                            
                        Toggle("Reminder Notification", isOn: $reminderActivation)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                            
                        Button {} label: {
                            Text("Homescreen Widgets")
                                .fontWeight(.semibold)
                                
                            Spacer()
                                
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                            
                    } header: {
                        Text("App Settings")
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                    }
                    
                    Section {
                        Button {} label: {
                            Text("📭 Contact Support")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                        Button {} label: {
                            Text("📖 About the app")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                        Button {} label: {
                            Text("🗑️ Delete account & all your data")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.red)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                        Button {
                            Task {
                                try await authViewModel.signOut()
                            }
                        } label: {
                            Text("👋 Sing Out")
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.red)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                        
                    } header: {
                        Text("Help & Support")
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                try await authViewModel.fetchUserProfile()
                updateViewFromProfile()
            }
        }
        .onChange(of: authViewModel.profile) { _ in
            updateViewFromProfile()
        }
    }

    // Update the view's state variables with the profile data
    private func updateViewFromProfile() {
        if let profile = authViewModel.profile?.first {
            name = profile.name
            email = profile.email
            selectedCurrency = Currency.fromString(profile.chosenCurrency) ?? .usd
        }
    }
}
