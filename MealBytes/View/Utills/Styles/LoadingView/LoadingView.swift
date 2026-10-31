//
//  LoadingView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/04/2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }
    }
}
