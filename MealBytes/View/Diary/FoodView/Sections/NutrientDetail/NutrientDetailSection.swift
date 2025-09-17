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
                    
                    ForEach(nutrientDetails, id: \.id) { nutrient in
                        HStack {
                            Text(nutrient.type.title)
                                .foregroundStyle(
                                    nutrient.isSubValue ? .secondary : .primary
                                )
                                .font(.subheadline)
                                .frame(maxWidth: .infinity,alignment: .leading)
                            
                            Text(nutrient.formattedValue)
                                .foregroundStyle(
                                    nutrient.isSubValue ? .secondary : .primary
                                )
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 4)
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
