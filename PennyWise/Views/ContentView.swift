//
//  ContentView.swift
//  PennyWise
//
//  Created by Bart Tynior on 09/10/2024.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        if authViewModel.isAuthenticated {
            MainContainerView()
        } else {
            WelcomeView()
        }
    }
}
