//
//  LoginLoadingView.swift
//  MealBytes
//
//  Created by Porshe on 06/04/2025.
//

import SwiftUI

struct LoginLoadingView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .customGreen))
                }
            }
        }
    }
}
