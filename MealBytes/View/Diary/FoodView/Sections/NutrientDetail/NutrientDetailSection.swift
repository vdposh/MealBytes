//
//  NutrientDetailSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientDetailSectionView: View {
    let title: String
    let nutrientDetails: [NutrientDetail]
    
    var body: some View {
        Section {
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            ForEach(nutrientDetails, id: \.id) { nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundColor(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(nutrient.formattedValue)
                        .foregroundColor(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
        }
    }
}
