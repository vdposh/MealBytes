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
                
                Picker(
                    "Height unit",
                    selection: $rdiViewModel.selectedHeightUnit
                ) {
                    if rdiViewModel.selectedHeightUnit == .notSelected {
                        Text("Not Selected").tag(HeightUnit.notSelected)
                    }
                    ForEach(HeightUnit.allCases.filter { $0 != .notSelected },
                            id: \.self) { height in
                        Text(height.rawValue).tag(height)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(rdiViewModel.selectedHeightUnit.accentColor)
            }
        } header: {
            Text("Height Details")
        } footer: {
            Text("Enter height and, if necessary, adjust the unit (centimeters or inches).")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
