//
//  HeaderButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 31.07.2026.
//

import SwiftUI

struct HeaderButtonView: View {
    let mealType: MealType
    let title: String
    let calories: Double
    let fat: Double
    let carbs: Double
    let protein: Double
    let hasItems: Bool
    let isExpanded: Bool
    let showNutrients: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    HeaderTextView(mealType: mealType, title: title)
                    
                    if hasItems && showNutrients {
                        NutrientSummaryView(
                            calories: calories,
                            fat: fat,
                            carbs: carbs,
                            protein: protein
                        )
                    }
                }
                
                if hasItems {
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.default, value: isExpanded)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .disabled(!hasItems)
        .listRowInsets(.all, 0)
        .buttonStyle(ButtonStyleInvisible())
    }
}

#Preview {
    PreviewContentView.contentView
}
