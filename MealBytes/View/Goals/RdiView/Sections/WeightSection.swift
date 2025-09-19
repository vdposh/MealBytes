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
            VStack(spacing: 20) {
                ServingTextFieldView(
                    text: $rdiViewModel.weight,
                    title: "Weight",
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.weight
                    ),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .weight)
                
                Picker(
                    "Weight Unit",
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
                .pickerStyle(.menu)
                .tint(rdiViewModel.selectedWeightUnit.selectedColor)
                .padding(.bottom, 4)
            }
        } footer: {
            Text("Enter weight and adjust the unit as needed (kilograms or pounds).")
        }
        .id("weightField")
    }
}

enum WeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case kg = "kg"
    case lbs = "lbs"
    
    var selectedColor: Color {
        switch self {
        case .notSelected: return .customRed
        default: return .accentColor
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
