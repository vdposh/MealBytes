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
            HStack {
                if personalIntakeViewModel.isValid {
                    Text(NutrientType.calories.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(
                    personalIntakeViewModel
                        .text(
                            for: personalIntakeViewModel
                                .calculatedPersonalIntake,
                            useUnit: false
                        )
                )
            }
            
            if let macros = personalIntakeViewModel.macroNutrients {
                HStack {
                    Text(NutrientType.fat.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(macros.fat.asWhole())
                }
                
                HStack {
                    Text(NutrientType.carbohydrate.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(macros.carbs.asWhole())
                }
                
                HStack {
                    Text(NutrientType.protein.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(macros.protein.asWhole())
                }
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
