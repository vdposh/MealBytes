//
//  NutrientValueSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/09/2025.
//

import SwiftUI

struct NutrientValueSection: View {
    let nutrients: [NutrientValue]
    var isFoodView: Bool = false
    
    var body: some View {
        ForEach(
            Array(nutrients.enumerated()),
            id: \.element.id
        ) { index, nutrient in
            let isNutrientTotals = (
                nutrient.type == .calories || nutrient.type == .protein
            ) && !isFoodView
            let isNutrientTotalsCalories = nutrient.type == .calories &&
            !isFoodView
            let isLastElement = index == nutrients.count - 1 && isFoodView
            
            VStack(spacing: 0) {
                nutrientRow(for: nutrient)
                    .padding(.vertical, isNutrientTotals ? 10 : 0)
                    .padding(.top, isNutrientTotalsCalories ? 6 : 0)
                
                if isNutrientTotals {
                    Rectangle()
                        .frame(height: 4)
                        .foregroundStyle(Color(.systemGray3))
                }
            }
            .listRowSeparator(
                isNutrientTotals || isLastElement ? .hidden : .visible,
                edges: .bottom
            )
            
            if isNutrientTotalsCalories {
                Picker(
                    "",
                    selection: .constant(1)
                ) {
                    Text("% Daily Value*").tag(1)
                }
                .tint(.accent)
                .padding(.top, 4)
            }
        }
        .lineLimit(1)
        .transaction { $0.animation = nil }
        .listRowInsets(.vertical, 0)
        
        if !isFoodView {
            LearnMoreTextView()
        }
    }
    
    @ViewBuilder
    private func nutrientRow(for nutrient: NutrientValue) -> some View {
        let isCalories = nutrient.type == .calories
        let isServingSize = nutrient.type == .servingSize
        let isSubValue = nutrient.isSubValue
        let isAddedSugars = nutrient.type == .addedSugars
        let isNutritionFacts = isFoodView || isCalories || isServingSize
        
        HStack {
            HStack(spacing: 4) {
                if isAddedSugars {
                    Text("Includes \(nutrient.formattedValue) Added Sugars")
                        .frame(
                            maxWidth: isNutritionFacts ? .infinity : nil,
                            alignment: .leading
                        )
                } else {
                    Text(nutrient.displayTitle)
                        .fontWeight(
                            isFoodView ? nil : (isSubValue ? nil : .bold)
                        )
                        .frame(
                            maxWidth: isNutritionFacts ? .infinity : nil,
                            alignment: .leading
                        )
                    
                    Text(nutrient.formattedValue)
                        .layoutPriority(1)
                        .fontWeight(
                            isFoodView ? nil : (isCalories ? .bold : nil)
                        )
                }
            }
            .frame(
                maxWidth: !isNutritionFacts ? .infinity : nil,
                alignment: .leading
            )
            
            if !isNutritionFacts, let dailyValue = nutrient.type.dailyValue {
                Text((nutrient.value / dailyValue).asPercentage())
            }
        }
        .font(isFoodView ? nil : (isCalories ? .title2 : nil))
        .padding(.leading, nutrient.type.leadingPadding)
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
