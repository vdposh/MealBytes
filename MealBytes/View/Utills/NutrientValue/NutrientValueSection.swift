//
//  NutrientValueSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/09/2025.
//

import SwiftUI

struct NutrientValueSection: View {
    let nutrients: [NutrientValue]
    let isExpandable: Binding<Bool>?
    var emptyMealItems: Bool = false
    var useServing: Bool = false
    var macroDistribution: [NutrientType: Int]? = nil
    var intake: String? = nil
    var intakePercentage: String? = nil
    
    var body: some View {
        Section {
            ForEach(nutrients) { nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundStyle(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        if nutrient.type == .calories {
                            Text(
                                emptyMealItems
                                ? "-"
                                : nutrient.formattedValue
                            )
                            .foregroundStyle(
                                nutrient.isSubValue ? .secondary : .primary
                            )
                            
                            if let intake, !emptyMealItems {
                                Text("/")
                                    .foregroundStyle(.secondary)
                                Text(intake)
                                    .foregroundStyle(.secondary)
                            }
                            
                            if let intakePercentage {
                                if useServing {
                                    Text("/")
                                        .foregroundStyle(.secondary)
                                    Text(intakePercentage)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("(\(intakePercentage))")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } else {
                            Text(
                                emptyMealItems
                                ? "-"
                                : nutrient.formattedValue
                            )
                            .foregroundStyle(
                                nutrient.isSubValue ? .secondary : .primary
                            )
                        }
                        
                        if let macroDistribution,
                           [.fat, .carbohydrate, .protein].contains(
                            nutrient.type
                           ),
                           let percent = macroDistribution[nutrient.type] {
                            Text("/")
                                .foregroundStyle(.secondary)
                            Text("\(percent)%")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                    .lineLimit(1)
                    .layoutPriority(1)
                }
            }
            .frame(height: 23)
            
            if let isExpandable, !emptyMealItems {
                ShowHideButtonView(isExpanded: isExpandable)
            }
        }
        .transaction { $0.animation = nil }
    }
}

#Preview {
    PreviewContentView.contentView
}
