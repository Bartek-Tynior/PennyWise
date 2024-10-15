//
//  SettingsView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                // User Profile Picture
                Image(systemName: "person.circle.fill") // Use your actual image asset here
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.top, 30)
                
                // User Info
                Text("Chris Newton")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                // Custom Section Layout Without Gray Background
                VStack(spacing: 20) {
                    // Account Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Account")
                            .font(.headline)
                            .bold()
                            .padding(.leading)
                        
                        HStack {
                            Text("Name")
                            Spacer()
                            Text("Chris Newton")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        
                        HStack {
                            Text("Email")
                            Spacer()
                            Text("chris.newton@gmail.com")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                    }
                    
                    // App Settings Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("App Settings")
                            .font(.headline)
                            .bold()
                            .padding(.leading)
                        
                        HStack {
                            Text("Currency")
                            Spacer()
                            Text("USD")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                    }
                    
                    // Help & Support Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Help & Support")
                            .font(.headline)
                            .bold()
                            .padding(.leading)
                        
                        Button(action: {
                            // Handle Contact Support
                        }) {
                            HStack {
                                Text("Contact Support")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        
                        Button(action: {
                            // Handle Delete Account Action
                        }) {
                            Text("Delete Account & Data")
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white)
                        }
                        
                        Button(action: {
                            // Handle Log Out Action
                            Task {
                                try await authViewModel.signOut()
                            }
                        }) {
                            Text("Log Out")
                                .foregroundColor(.red)
                                .padding()
                                .background(Color.white)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
       }
   }
