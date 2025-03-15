//
//  DetailedNutrientRow.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct DetailedNutrientRow: View {
    let nutrient: DetailedNutrient
    
    var body: some View {
        HStack {
            Text(nutrient.type.title)
                .foregroundColor(nutrient.isSubValue ? .gray : .primary)
            Spacer()
            Text(nutrient.formattedValue)
                .foregroundColor(nutrient.isSubValue ? .gray : .primary)
                .lineLimit(1)
        }
    }
}
