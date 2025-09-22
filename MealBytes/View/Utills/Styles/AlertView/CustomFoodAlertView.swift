//
//  CustomFoodAlertView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct CustomFoodAlertView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "text.badge.plus")
                    .foregroundStyle(Color.accent.opacity(0.8))
                    .frame(width: 20)
                Text("Added to Diary")
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            .font(.system(size: 14.5))
            .padding(.vertical, 16)
            .padding(.horizontal, 18)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 140)
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
