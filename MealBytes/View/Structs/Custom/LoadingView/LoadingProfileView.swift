//
//  LoadingProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/07/2025.
//

import SwiftUI

struct LoadingProfileView: View {
    var body: some View {
        ZStack {
            Color.primary
                .opacity(0.2)
                .ignoresSafeArea()
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    PreviewContentView.contentView
}
