//
//  MainContainerView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//
import SwiftUI

struct MainContainerView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        VStack {
            
            TopNavBar()
            
            Spacer()

            switch selectedTab {
            case .home:
                DashboardView()
            case .transactions:
                TransactionsView()
            case .settings:
                SettingsView()
            }

            Spacer()

            BottomNav(selectedTab: $selectedTab)
        }
    }
}
