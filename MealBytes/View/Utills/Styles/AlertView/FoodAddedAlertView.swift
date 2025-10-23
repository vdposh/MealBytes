//
//  FoodAddedAlertView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct FoodAddedAlertView: View {
    @Binding var isVisible: Bool
    @State private var symbolEffect = true
    
    var body: some View {
        Label {
            Text("Added to Diary")
                .fontWeight(.medium)
                .font(.subheadline)
        } icon: {
            Image(systemName: "text.badge.plus")
                .symbolEffect(.drawOn, isActive: symbolEffect)
                .symbolColorRenderingMode(.gradient)
        }
        .labelIconToTitleSpacing(10)
        .foregroundStyle(.secondary)
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .containerRelativeFrame(.vertical) { height, _ in
            height * 0.45
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .opacity(isVisible ? 1 : 0)
        .allowsHitTesting(false)
        .ignoresSafeArea()
        .onChange(of: isVisible) {
            if isVisible {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    symbolEffect = false
                }
            } else {
                symbolEffect = true
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
