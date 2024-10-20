//
//  CustomPicker.swift
//  PennyWise
//
//  Created by Bart Tynior on 18/10/2024.
//

import SwiftUI

enum TimeTypes: String, CaseIterable, Identifiable {
    case monthly, weekly
    var id: String { self.rawValue }
}

struct CustomPicker<SelectionValue, Content>: View where SelectionValue == Content.Element, Content: RandomAccessCollection, Content.Element: Identifiable & Equatable, Content.Element.ID == String {

    @Binding var selection: SelectionValue?
    let items: () -> Content

    @State var isPicking = false
    @State var hoveredItem: SelectionValue?
    @Environment(\.isEnabled) var isEnabled

    let arrowSize: CGFloat = 16
    let cornerRadius: CGFloat = 12

    // Extract the button for each item into a separate view
    func itemButton(item: SelectionValue) -> some View {
        Button {
            selection = item
            isPicking.toggle()
        } label: {
            Text(item.id.capitalized)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(hoveredItem == item ? Color.accentColor.opacity(0.8) : Color.clear)
                        .padding(.horizontal, 8)
                }
                .onHover { isHovered in
                    if isHovered {
                        hoveredItem = item
                    }
                }
        }
        .buttonStyle(.plain)
    }

    var body: some View {

        // Select Button - Selected item
        HStack {
            Text(selection?.id.capitalized ?? "Select")
                .foregroundColor(selection == nil ? .gray : .white)  // Placeholder color like your design
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(.white)
                .rotationEffect(.degrees(isPicking ? 180 : 0)) // Rotate the arrow when dropdown is open
                .animation(.easeInOut, value: isPicking)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.gray.opacity(0.2))  // Dark background color matching the input fields
        )
        .contentShape(Rectangle())
        .onTapGesture {
            isPicking.toggle()
        }
        .overlay(alignment: .topLeading) {
            VStack {
                if isPicking {
                    Spacer(minLength: 60) // Spacing to prevent overlap with the original button

                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(items()) { item in
                                itemButton(item: item)  // Use the extracted button view here
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .scrollIndicators(.never)
                    .frame(height: 100)  // Adjust height to fit design
                    .background(Color.gray.opacity(0.2)) // Dark background for dropdown
                    .cornerRadius(cornerRadius)
                    .shadow(radius: 4)
                    .transition(.scale(scale: 0.8, anchor: .top)
                        .combined(with: .opacity)
                        .combined(with: .offset(y: -10)))
                }
            }
            .padding(.top, 5)
        }
        .padding(.horizontal, 12)
        .opacity(isEnabled ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.12), value: isPicking)
        .zIndex(1)
    }
}

#Preview {
    VStack {
        CustomPicker(selection: .constant(nil)) {
            TimeTypes.allCases
        }
    }
    .preferredColorScheme(.dark)
    .frame(width: 280, height: 280, alignment: .top)
    .padding()
}
