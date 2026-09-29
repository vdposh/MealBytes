//
//  HeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct HeightSection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        CollapsibleRow(
            title: "Height",
            value: personalIntakeViewModel.height.isEmpty
            ? ""
            : personalIntakeViewModel.heightText,
            isExpanded: personalIntakeViewModel.isExpandedHeight,
            onToggle: {
                personalIntakeViewModel.toggleSection(.height)
            }
        ) {
            WheelPickerRow(
                text: $personalIntakeViewModel.height,
                selectedUnit: $personalIntakeViewModel.selectedHeightUnit,
                integerRange: { unit in
                    unit == .cm ? 100...250 : 39...98
                },
                minValue: { unit in
                    unit == .cm ? 100 : 39
                }
            )
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case inches = "inches"
}

#Preview {
    PreviewGoalsView.goalsView
}
