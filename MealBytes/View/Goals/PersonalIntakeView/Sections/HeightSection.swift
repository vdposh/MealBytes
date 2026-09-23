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
        NavigationLink {
            MeasurementSelectionView(
                value: $personalIntakeViewModel.height,
                selectedUnit: $personalIntakeViewModel.selectedHeightUnit,
                title: "Height",
                maxIntegerDigits: 3,
                normalizeAction: personalIntakeViewModel.normalizeHeight
            )
        } label: {
            LabeledContent {
                if !personalIntakeViewModel.height.isEmpty {
                    Text("\(personalIntakeViewModel.height) \(personalIntakeViewModel.selectedHeightUnit.rawValue)")
                }
            } label: {
                Text("Height")
            }
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case inches = "inches"
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
