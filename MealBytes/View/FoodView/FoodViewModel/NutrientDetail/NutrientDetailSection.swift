//
//  NutrientDetailSection.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientDetailSectionView: View {
    let title: String
    let nutrientDetails: [NutrientDetail]
    
    var body: some View {
        Section {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            ForEach(nutrientDetails, id: \.id) { nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundColor(nutrient.isSubValue ? .gray : .primary)
                        .font(.subheadline)
                    Spacer()
                    Text(nutrient.formattedValue)
                        .foregroundColor(nutrient.isSubValue ? .gray : .primary)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
        }
    }
}
