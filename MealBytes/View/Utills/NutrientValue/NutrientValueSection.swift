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
                    
                    Text(
                        isPlaceholder
                        ? "-"
                        : nutrient.formattedValue
                    )
                    .foregroundStyle(
                        nutrient.isSubValue ? .secondary : .primary
                    )
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
