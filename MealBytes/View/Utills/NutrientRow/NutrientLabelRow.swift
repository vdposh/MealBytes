//
//  NutrientLabelRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25.09.2026.
//

import SwiftUI

struct NutrientLabelRow: View {
    let type: NutrientType
    let value: String
    var unit: UnitNutrients? = nil
    
    var displayUnit: UnitNutrients {
        unit ?? type.unitType
    }
    
    var body: some View {
        HStack {
            Label {
                Text(type.title)
            } icon: {
                Image(systemName: type.iconName)
                    .fontWeight(.semibold)
                    .foregroundStyle(type.iconColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 4) {
                Text(value)
                Text(displayUnit.unitDescription(for: Double(value) ?? 0))
            }
        }
    }
}

#Preview {
    PreviewGoalsView.goalsView
}

#Preview {
    PreviewContentView.contentView
}
