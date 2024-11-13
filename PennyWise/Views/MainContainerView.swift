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

                CalendarModal(
                    isPresented: $showCalendarModal,
                    title: "Access photos?",
                    message: "This lets you choose which photos you want to add to this project.",
                    buttonTitle: "Give Access"
                ) {
                    print("Pass to viewModel")
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}
