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
    var isPlaceholder: Bool = false
    var macroDistribution: [NutrientType: Int]? = nil
    
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
                        Text(
                            isPlaceholder
                            ? "-"
                            : nutrient.formattedValue
                        )
                        .foregroundStyle(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        
                        if let macroDistribution,
                           [.fat, .carbohydrate, .protein].contains(
                            nutrient.type
                           ),
                           let percent = macroDistribution[nutrient.type] {
                            Text("/")
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Text("\(percent)%")
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.subheadline)
                    .lineLimit(1)
                }
            }
            
            if let isExpandable, !isPlaceholder {
                ShowHideButtonView(isExpanded: isExpandable)
            }
        }
        .transaction { $0.animation = nil }
    }
}

#Preview {
    PreviewContentView.contentView
}
