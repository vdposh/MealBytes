//
//  WeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct WeightSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        NavigationLink {
            MeasurementSelectionView(
                value: $rdiViewModel.weight,
                selectedUnit: $rdiViewModel.selectedWeightUnit,
                title: "Weight",
                maxIntegerDigits: 3,
                normalizeAction: rdiViewModel.normalizeWeight
            )
        } label: {
            LabeledContent {
                if !rdiViewModel.weight.isEmpty {
                    Text("\(rdiViewModel.weight) \(rdiViewModel.selectedWeightUnit.rawValue)")
                }
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
    PreviewRdiView.rdiView
}
