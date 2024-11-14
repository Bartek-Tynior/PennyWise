//
//  MainContainerView.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//
import SwiftUI

struct MainContainerView: View {
    @State private var selectedTab: Tab = .home
    @State private var showCalendarModal = false // Global modal state

    var body: some View {
        ZStack {
            VStack {
                switch selectedTab {
                case .home:
                    DashboardView(showCalendarModal: $showCalendarModal)
                case .transactions:
                    TransactionsView()
                case .settings:
                    SettingsView()
                }

                Spacer()

                BottomNav(selectedTab: $selectedTab)
            }

            // Global Calendar Modal Overlay
            if showCalendarModal {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showCalendarModal = false
                        }
                    }

                CalendarModal(isPresented: $showCalendarModal)
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}
