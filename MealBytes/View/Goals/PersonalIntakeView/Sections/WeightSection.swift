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
        CollapsibleRow(
            title: "Weight",
            value: personalIntakeViewModel.weight.isEmpty
            ? ""
            : personalIntakeViewModel.weightText,
            isExpanded: personalIntakeViewModel.isExpandedWeight,
            onToggle: {
                personalIntakeViewModel.toggleSection(.weight)
            }
        ) {
            DecimalPickerRow(
                text: $personalIntakeViewModel.weight,
                selectedUnit: $personalIntakeViewModel.selectedWeightUnit,
                integerRange: { unit in
                    unit == .kg ? 30...200 : 66...440
                },
                minValue: { unit in
                    unit == .kg ? 30 : 66
                }
            )
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
