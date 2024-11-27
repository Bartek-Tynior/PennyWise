//
//  FontWeight.swift
//  PennyWise
//
//  Created by Bart Tynior on 28/11/2024.
//

import SwiftUI

enum FontWeight {
    case light
    case regular
    case medium
    case semiBold
    case bold
    case black
}

extension Font {
    static let customFont: (FontWeight, CGFloat) -> Font = { fontType, size in
        switch fontType {
        case .light:
            Font.custom("Nunito-Light", size: size)
        case .regular:
            Font.custom("Nunito-Regular", size: size)
        case .medium:
            Font.custom("Nunito-Medium", size: size)
        case .semiBold:
            Font.custom("Nunito-SemiBold", size: size)
        case .bold:
            Font.custom("Nunito-Bold", size: size)
        case .black:
            Font.custom("Nunito-Black", size: size)
        }
    }
}

extension Text {
    func customFont(_ fontWeight: FontWeight? = .regular, _ size: CGFloat? = nil) -> Text {
        return self.font(.customFont(fontWeight ?? .regular, size ?? 16))
    }
}
