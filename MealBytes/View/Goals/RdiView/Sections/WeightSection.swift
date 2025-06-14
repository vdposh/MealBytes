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
            VStack(alignment: .leading, spacing: 11) {
                ServingTextFieldView(
                    text: $rdiViewModel.weight,
                    title: "Weight",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.weight),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .weight)
                
                Picker(
                    "Weight unit",
                    selection: $rdiViewModel.selectedWeightUnit
                ) {
                    if rdiViewModel.selectedWeightUnit == .notSelected {
                        Text("Not Selected").tag(WeightUnit.notSelected)
                    }
                    ForEach(WeightUnit.allCases.filter { $0 != .notSelected },
                            id: \.self) { weight in
                        Text(weight.rawValue).tag(weight)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(rdiViewModel.selectedWeightUnit.accentColor)
            }
        } header: {
            Text("Weight Details")
        } footer: {
            Text("Enter weight and adjust the unit as needed (kilograms or pounds).")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
