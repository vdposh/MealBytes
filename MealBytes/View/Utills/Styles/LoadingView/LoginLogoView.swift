//
//  LoginLogoView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10/04/2025.
//

import SwiftUI

struct LoginLogoView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if colorScheme == .light {
                    LinearGradient(
                        colors: backgroundLightGradientColors,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                } else {
                    Color.clear
                        .ignoresSafeArea()
                }
                
                gradientMaskedImage(width: geometry.size.width * 0.28)
            }
        }
    }
    
    private var backgroundLightGradientColors: [Color] {
        [Color("customWhiteLight"), Color("customWhiteDark")]
    }
    
    private var logoGradientColors: [Color] {
        [Color("customGreenLight"), Color("customGreenDark")]
    }
    
    private func gradientMaskedImage(width: CGFloat) -> some View {
        Image("smartApple")
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .overlay(
                LinearGradient(
                    colors: logoGradientColors,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .mask(
                Image("smartApple")
                    .resizable()
                    .scaledToFit()
            )
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    LoginLogoView()
}
