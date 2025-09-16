//
//  NutrientDetailSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientDetailSection: View {
    let nutrientDetails: [NutrientDetail]
    
    var body: some View {
        SectionStyleView(
            mainContent: {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Detailed Information")
                        .font(.callout)
                        .fontWeight(.medium)
                        .padding(.horizontal, 4)
                    
                    ForEach(
                        Array(nutrientDetails.enumerated()),
                        id: \.1.id
                    ) { index, nutrient in
                        HStack {
                            Text(nutrient.type.title)
                                .foregroundStyle(
                                    nutrient.isSubValue ? .secondary : .primary
                                )
                                .font(.subheadline)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            
                            Text(nutrient.formattedValue)
                                .foregroundStyle(
                                    nutrient.isSubValue ? .secondary : .primary
                                )
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        .overlay {
                            if index != 0 {
                                SeparatorView(topInset: -22)
                            }
                        }
                        .padding(.horizontal, 4)
                        .padding(
                            .vertical,
                            index == nutrientDetails.count - 1 ? 0 : 6
                        )
                        .padding(
                            .top,
                            index == nutrientDetails.count - 1 ? 6 : 0
                        )
                    }
                }
            },
            layout: .textStyle,
            hasTopTextPadding: false,
            useLargeCornerRadius: true
        )
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
