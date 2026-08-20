//
//  FoodAddedAlertView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct FoodAddedAlertView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        Label {
            Text("Added to Diary")
                .fontWeight(.medium)
                .font(.subheadline)
        } icon: {
            Image(systemName: "text.badge.plus")
                .symbolColorRenderingMode(.gradient)
        }
        .foregroundStyle(.secondary)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(.regularMaterial)
        .glassEffect(.clear)
        .clipShape(Capsule())
        .containerRelativeFrame(.vertical) { height, _ in
            height * 0.45
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .opacity(isVisible ? 1 : 0)
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }
}

#Preview {
    PreviewContentView.contentView
}
