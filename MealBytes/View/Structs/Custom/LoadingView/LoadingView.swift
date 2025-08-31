//
//  LoadingView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: .accentColor)
                )
        }
    }
}
