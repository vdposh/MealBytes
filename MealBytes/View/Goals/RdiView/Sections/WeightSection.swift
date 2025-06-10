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
                
                Picker("Unit", selection: $rdiViewModel.selectedWeightUnit) {
                    ForEach(WeightUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
        } header: {
            Text("Weight")
        } footer: {
            Text("Set the weight and unit (kg or lbs).")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
