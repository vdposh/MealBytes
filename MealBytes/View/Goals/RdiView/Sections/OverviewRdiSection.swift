//
//  OverviewRdiSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct OverviewRdiSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            HStack {
                if rdiViewModel.isValid {
                    Text(NutrientType.calories.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(
                    rdiViewModel
                        .text(for: rdiViewModel.calculatedRdi, useUnit: false)
                )
            }
            
            if let macros = rdiViewModel.macroNutrients {
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
    PreviewRdiView.rdiView
}

#Preview {
    PreviewContentView.contentView
}
