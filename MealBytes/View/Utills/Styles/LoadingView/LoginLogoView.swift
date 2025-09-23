//
//  LoginLogoView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10/04/2025.
//

import SwiftUI

struct LoginLogoView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.clear)
                    .ignoresSafeArea()
                
                gradientMaskedImage(width: geometry.size.width * 0.3)
            }
        }
    }
    
    private var gradientColors: [Color] {
        [
            Color(red: 100/255, green: 200/255, blue: 70/255),
            Color(red: 0/255, green: 130/255, blue: 40/255)
        ]
    }
    
    private func gradientMaskedImage(width: CGFloat) -> some View {
        Image("smartApple")
            .resizable()
            .scaledToFit()
            .frame(width: width)
            .overlay(
                LinearGradient(
                    colors: gradientColors,
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
