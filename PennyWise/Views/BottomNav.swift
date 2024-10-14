//
//  BottomNav.swift
//  PennyWise
//
//  Created by Bart Tynior on 11/10/2024.
//

import SwiftUI

struct BottomNav: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation // Namespace for animation

    // Colors for each section
    let colors: [Tab: Color] = [
        .home: Color.red.opacity(0.2),
        .transactions: Color.blue.opacity(0.2),
        .settings: Color.green.opacity(0.2)
    ]

    let iconColors: [Tab: Color] = [
        .home: Color.red,
        .transactions: Color.blue,
        .settings: Color.green
    ]

    var body: some View {
        HStack {
            Spacer()

            // Home Button
            navItem(icon: "house", text: "Home", tab: .home)

            Spacer()

            // Transactions Button
            navItem(icon: "arrow.left.arrow.right", text: "Transactions", tab: .transactions)

            Spacer()

            // Settings Button
            navItem(icon: "gearshape", text: "Settings", tab: .settings)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    // Helper function to create nav items
    func navItem(icon: String, text: String, tab: Tab) -> some View {
        Button(action: {
            withAnimation(.smooth) {
                selectedTab = tab
            }
        }) {
            VStack {
                if selectedTab == tab {
                    ZStack {
                        // Moving background element with dynamic color and width based on content
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colors[tab] ?? Color.gray.opacity(0.2))
                            .frame(width: textWidth(for: text), height: 40)
                            .matchedGeometryEffect(id: "background", in: animation)

                        // Icon and text for the selected tab
                        HStack {
                            Image(systemName: icon)
                                .font(.system(size: 24))
                                .foregroundColor(iconColors[tab])
                            Text(text)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(iconColors[tab])
                        }
                    }
                } else {
                    // Only the icon for unselected tabs, color based on the tab
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }
        }
        .foregroundColor(selectedTab == tab ? .primary : .gray)
    }

    // Function to calculate the width based on text
    func textWidth(for text: String) -> CGFloat {
        // Dynamically calculate width based on text content
        let font = UIFont.systemFont(ofSize: 14)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 60 // Padding around text and icon
    }
}

enum Tab {
    case home, transactions, settings
}
