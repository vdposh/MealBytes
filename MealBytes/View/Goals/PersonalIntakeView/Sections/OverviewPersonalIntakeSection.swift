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
            if personalIntakeViewModel.isValid {
                NutrientLabelRow(
                    type: .calories,
                    value: personalIntakeViewModel.text(
                        for: personalIntakeViewModel.calculatedPersonalIntake,
                        useUnit: false
                    )
                )
            }
            
            if let macros = personalIntakeViewModel.macroNutrients {
                NutrientLabelRow(
                    type: .fat,
                    value: macros.fat.asWhole()
                )
                
                NutrientLabelRow(
                    type: .carbohydrate,
                    value: macros.carbs.asWhole()
                )
                
                NutrientLabelRow(
                    type: .protein,
                    value: macros.protein.asWhole()
                )
            }
        }
    }
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}

#Preview {
    PreviewContentView.contentView
}
