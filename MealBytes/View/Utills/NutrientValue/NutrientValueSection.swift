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
                        .font(.callout)
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
                                Text("(\(intakePercentage))")
                                    .foregroundStyle(.secondary)
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
                            
                            Text((Double(percent) / 100).asPercentage())
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.callout)
                    .lineLimit(1)
                    .layoutPriority(1)
                }
            }
            
            if let isExpandable, !emptyMealItems {
                Button {
                    withAnimation {
                        isExpandable.wrappedValue.toggle()
                    }
                } label: {
                    Text(isExpandable.wrappedValue ? "Hide" : "More")
                }
            }
        } header: {
            Text("Nutrient total")
        }
        .transaction { $0.animation = nil }
    }
}

#Preview {
    PreviewContentView.contentView
}
