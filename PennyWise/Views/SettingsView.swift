//
//  SettingsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name: String = "Bart"
    @State private var currency: String = "EUR"
    @State private var email: String = "btynior@gmail.com"
    @State private var reminderActivation: Bool = false
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
                        Text("B")
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

                        Button {} label: {
                            Text("Change Password")
                                .fontWeight(.semibold)
                                
                            Spacer()
                                
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .foregroundStyle(.white)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                    } header: {
                        Text("Account Settings")
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                    }
                        
                    Section {
                        TextField("Currency", text: $currency)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundStyle(.white)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                            
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
    }
}

#Preview {
    SettingsView()
}
