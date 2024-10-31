//
//  AppIntroView.swift
//  PennyWise
//
//  Created by Bart Tynior on 29/10/2024.
//

import SwiftUI

struct AppIntroView: View {
    var onFinish: () -> Void
    var onPrevious: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Penny")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Wise.")
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)
            }
            .padding(.vertical, 40)
            
            VStack(alignment: .leading, spacing: 40) {
                Text("Welcome to PennyWise 👋")
                    .foregroundStyle(.gray)
                    .font(.title)
                    .multilineTextAlignment(.center)

                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer a varius augue. Maecenas in sem enim. Phasellus commodo risus at ante lobortis laoreet. Aliquam vitae dui mollis, blandit nibh in, pretium libero. Sed mollis sapien eget ex dapibus, id consectetur lacus placerat. Aliquam erat volutpat. Vivamus eu pulvinar metus. Suspendisse tincidunt, purus sit amet venenatis fermentum, nibh libero tristique lectus, vitae venenatis massa dui ac tortor. Morbi non purus nec nulla rhoncus commodo. In et ligula nisl. Ut laoreet tempus dolor hendrerit pulvinar.")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: onPrevious) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.purple)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                
                Button(action: onFinish) {
                    Text("Finish")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
        }
        .background(Color.black.opacity(0.9).edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
    }
}
