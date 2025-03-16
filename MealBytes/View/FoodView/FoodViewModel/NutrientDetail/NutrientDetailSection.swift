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
            
            ForEach(nutrientDetails) { nutrient in
                NutrientDetailRow(nutrient: nutrient)
            }
        }
    }
}
