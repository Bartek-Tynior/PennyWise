//
//  PennyWiseApp.swift
//  PennyWise
//
//  Created by Bart Tynior on 08/10/2024.
//

import SwiftUI

@main
struct PennyWiseApp: App {
    
    @StateObject var authViewModel = AuthViewModel()

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(authViewModel)
                    .onAppear {
                        Task {
                            await authViewModel.checkSession()
                        }
                    }
            }
        }
}
