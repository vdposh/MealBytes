//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    let label: String
    let value: Double
    let formatter: Formatter
    
    var body: some View {
        Text(label)
            .foregroundColor(.gray)
            .font(.subheadline)
        Text(formatter.formattedValue(value, unit: .empty))
            .foregroundColor(.gray)
            .font(.subheadline)
    }
}

#Preview {
    MainView()
}
