//
//  WeightSection.swift
//  MealBytes
//
//  Created by Porshe on 27/03/2025.
//

import SwiftUI

struct WeightSection: View {
    @FocusState var focusedField: Bool
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section(header: Text("Weight")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.weight,
                    title: "Weight",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.weight)
                )
                .focused($focusedField)
                
                Picker("Unit", selection: $rdiViewModel.selectedWeightUnit) {
                    ForEach(WeightUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .font(.callout)
            }
        }
    }
}
