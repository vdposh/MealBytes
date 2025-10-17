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
        if isVisible {
            Label {
                Text("Added to Diary")
                    .fontWeight(.medium)
                    .font(.subheadline)
            } icon: {
                Image(systemName: "text.badge.plus")
            }
            .labelIconToTitleSpacing(10)
            .foregroundStyle(.secondary)
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .containerRelativeFrame(.vertical) { height, _ in
                height * 0.45
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .allowsHitTesting(false)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
