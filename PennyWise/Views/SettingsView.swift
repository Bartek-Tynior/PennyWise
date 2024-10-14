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
        Button("Sign Out") {
            Task {
                try await authViewModel.signOut()
            }
        }
    }
}
