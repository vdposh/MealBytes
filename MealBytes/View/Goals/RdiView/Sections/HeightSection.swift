//
//  HeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct HeightSection: View {
    @FocusState var focusedField: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 11) {
                ServingTextFieldView(
                    text: $rdiViewModel.height,
                    title: "Height",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.height),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .height)
                
                Picker("Unit", selection: $rdiViewModel.selectedHeightUnit) {
                    ForEach(HeightUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
                .pickerStyle(.menu)
            }
        } header: {
            Text("Height")
        } footer: {
            Text("Adjust the height and unit (cm or inches).")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
