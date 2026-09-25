//
//  WeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct WeightSection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        NavigationLink {
            MeasurementSelectionView(
                value: $personalIntakeViewModel.weight,
                selectedUnit: $personalIntakeViewModel.selectedWeightUnit,
                title: "Weight",
                maxIntegerDigits: 3,
                normalizeAction: personalIntakeViewModel.normalizeWeight
            )
        } label: {
            LabeledContent {
                Text(personalIntakeViewModel.weightText)
            } label: {
                Text("Weight")
            }
        }
    }
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

#Preview {
    PreviewGoalsView.goalsView
}
