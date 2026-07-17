//
//  WeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct WeightSection: View {
    @FocusState var focus: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            ServingTextFieldView(
                text: $rdiViewModel.weight,
                maxIntegerDigits: 3
            )
            .focused($focus, equals: .weight)
            
            Picker(
                "Unit",
                selection: $rdiViewModel.selectedWeightUnit
            ) {
                ForEach(
                    WeightUnit.allCases,
                    id: \.self
                ) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .foregroundStyle(rdiViewModel.selectedWeightUnit.selectedColor)
        } header: {
            Text("Weight")
                .foregroundStyle(
                    rdiViewModel.fieldTitleColor(for: rdiViewModel.weight)
                )
        }
    }
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
    
    var selectedColor: Color {
        .primary
    }
}

#Preview {
    PreviewRdiView.rdiView
}
