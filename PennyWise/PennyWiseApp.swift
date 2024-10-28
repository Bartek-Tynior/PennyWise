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
    @StateObject private var appDataViewModel = AppDataViewModel()
    @StateObject private var helperViewModel = HelperViewModel()

        var body: some Scene {
            WindowGroup {
                ContentView()
                    .environmentObject(authViewModel)
                    .environmentObject(helperViewModel)
                    .environmentObject(appDataViewModel)
                    .onAppear {
                        Task {
                            await authViewModel.checkSession()
                        }
                    }
            }
        }
}
