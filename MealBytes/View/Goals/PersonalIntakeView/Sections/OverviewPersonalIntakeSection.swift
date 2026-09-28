//
//  OverviewPersonalIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct OverviewPersonalIntakeSection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Section {
            ForEach(
                [NutrientType.calories, .fat, .carbohydrate, .protein],
                id: \.self
            ) { type in
                NutrientLabelRow(
                    type: type,
                    value: personalIntakeViewModel.macroValues[type] ?? "0"
                )
            }
        } footer: {
            Text("Calculated from Body Profile")
        }
    }
}

#Preview {
    PreviewGoalsView.goalsView
}

#Preview {
    PreviewContentView.contentView
}
