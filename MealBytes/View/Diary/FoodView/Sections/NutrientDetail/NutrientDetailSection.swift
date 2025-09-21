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
        Section {
            Text("Detailed Information")
                .fontWeight(.medium)
                .listRowSeparator(.hidden)
                .padding(.top, 6)
            
            ForEach(nutrientDetails, id: \.id) { nutrient in
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
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
