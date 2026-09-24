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
                    Label {
                        Text(NutrientType.calories.title)
                    } icon: {
                        Image(systemName: "flame.fill")
                            .fontWeight(.semibold)
                            .foregroundStyle(.customCalories)
                    }
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
                    Label {
                        Text(NutrientType.fat.title)
                    } icon: {
                        Image(systemName: "f.circle.fill")
                            .fontWeight(.semibold)
                            .foregroundStyle(.customFat)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(macros.fat.asWhole())
                }
                
                HStack {
                    Label {
                        Text(NutrientType.carbohydrate.title)
                    } icon: {
                        Image(systemName: "c.circle.fill")
                            .fontWeight(.semibold)
                            .foregroundStyle(.customCarbs)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(macros.carbs.asWhole())
                }
                
                HStack {
                    Label {
                        Text(NutrientType.protein.title)
                    } icon: {
                        Image(systemName: "p.circle.fill")
                            .fontWeight(.semibold)
                            .foregroundStyle(.customProtein)
                    }
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
