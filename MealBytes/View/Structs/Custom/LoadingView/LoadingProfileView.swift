//
//  LoadingProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/07/2025.
//

import SwiftUI

struct LoadingProfileView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: Color {
        if colorScheme == .dark {
            Color(.darkText)
                .opacity(0.4)
        } else {
            Color.primary
                .opacity(0.2)
        }
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    PreviewContentView.contentView
}
