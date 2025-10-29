//
//  WeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct WeightSection: View {
    @FocusState var focusedField: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            ServingTextFieldView(
                text: $rdiViewModel.weight,
                placeholder: "Weight value",
                maxIntegerDigits: 3
            )
            .focused($focusedField, equals: .weight)
            
            Picker(
                "Weight unit",
                selection: $rdiViewModel.selectedWeightUnit
            ) {
                if rdiViewModel
                    .selectedWeightUnit == .notSelected {
                    Text("Not Selected")
                        .tag(WeightUnit.notSelected)
                }
                ForEach(
                    WeightUnit.allCases.filter {
                        $0 != .notSelected },
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
        } footer: {
            Text("Enter weight and adjust the unit as needed (kilograms or pounds).")
        }
    }
}

enum WeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case kg = "kg"
    case lbs = "lbs"
    
    var selectedColor: Color {
        switch self {
        case .notSelected: .customRed
        default: .primary
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
