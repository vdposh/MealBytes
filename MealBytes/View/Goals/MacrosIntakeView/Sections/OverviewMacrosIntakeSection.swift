//
//  OverviewMacrosIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct OverviewMacrosIntakeSection: View {
    @ObservedObject var macrosIntakeViewModel: MacrosIntakeViewModel
    
    var body: some View {
        Section {
            HStack {
                if macrosIntakeViewModel.isValid {
                    Text("Calories")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(
                    macrosIntakeViewModel
                        .text(
                            for: macrosIntakeViewModel.calories,
                            useUnit: false
                        )
                )
            }
        }
    }
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
