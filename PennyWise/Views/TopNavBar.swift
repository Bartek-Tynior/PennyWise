//
//  Navbar.swift
//  PennyWise
//
//  Created by Bart Tynior on 10/10/2024.
//

import SwiftUI

struct TopNavBar: View {
    var body: some View {
        HStack {
            Text("Penny")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.black)

            Text("Wise.")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
        }
    }
}

struct NavbarPreview: PreviewProvider {
    static var previews: some View {
        TopNavBar()
    }
}
