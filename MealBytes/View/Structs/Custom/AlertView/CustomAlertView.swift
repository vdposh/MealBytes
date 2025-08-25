//
//  CustomAlertView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25/08/2025.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isVisible: Bool
    var style: FoodAlertStyle
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: style.iconName)
                    .fontWeight(style.weight)
                Text(style.message)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .foregroundColor(style.foregroundColor)
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .background(
                Rectangle()
                    .fill(style.backgroundFill)
                    .background(.bar)
            )
            .cornerRadius(12)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 90)
            .allowsHitTesting(false)
        }
    }
}

enum FoodAlertStyle {
    case added
    case saved
    case removed
    
    var iconName: String {
        switch self {
        case .added, .saved: return "checkmark"
        case .removed: return "trash"
        }
    }
    
    var message: String {
        switch self {
        case .added: return "Added to Diary"
        case .saved: return "Food Saved"
        case .removed: return "Food Removed"
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .removed: return .medium
        default: return .bold
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .removed: return .customRed.opacity(0.85)
        default: return .customGreen.opacity(0.85)
        }
    }
    
    var backgroundFill: Color {
        switch self {
        case .removed: return .customRed.opacity(0.15)
        default: return .customGreen.opacity(0.15)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
