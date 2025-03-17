//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    let label: String
    let formattedValue: String

    var body: some View {
        Text(label)
            .foregroundColor(.gray)
            .font(.subheadline)
        Text(formattedValue)
            .foregroundColor(.gray)
            .font(.subheadline)
            .padding(.trailing, 5)
    }
}
