//
//  NutrientDetailRow.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct NutrientDetailRow: View {
    let title: String
    let value: Double
    let unit: String
    let isSubValue: Bool
    
    init(title: String,
         value: Double,
         unit: String,
         isSubValue: Bool = false) {
        self.title = title
        self.value = value
        self.unit = unit
        self.isSubValue = isSubValue
    }
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isSubValue ? .gray : .primary)
            Spacer()
            HStack {
                Text(Formatter().formattedValue(
                    value,
                    unit: Formatter.Unit(rawValue: unit) ?? .empty))
                .foregroundColor(isSubValue ? .gray : .primary)
                .lineLimit(1)
            }
        }
    }
}
