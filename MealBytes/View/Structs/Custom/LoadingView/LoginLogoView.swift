//
//  LoginLogoView.swift
//  MealBytes
//
//  Created by Porshe on 10/04/2025.
//

import SwiftUI

struct LoginLogoView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Image("smartApple")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.25)
                }
            }
        }
    }
}
