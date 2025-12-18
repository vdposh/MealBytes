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
            ServingTextFieldView(
                text: $rdiViewModel.height,
                placeholder: "Height value",
                maxIntegerDigits: 3
            )
            .focused($focusedField, equals: .height)
            
            Picker(
                "Height unit",
                selection: $rdiViewModel.selectedHeightUnit
            ) {
                if rdiViewModel.selectedHeightUnit == .notSelected {
                    Text("Not Selected")
                        .tag(HeightUnit.notSelected)
                }
                
                ForEach(
                    HeightUnit.allCases.filter { $0 != .notSelected },
                    id: \.self
                ) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
            .foregroundStyle(rdiViewModel.selectedHeightUnit.selectedColor)
        } header: {
            Text("Height")
                .foregroundStyle(
                    rdiViewModel.fieldTitleColor(for: rdiViewModel.height)
                )
        } footer: {
            Text("Enter height and, if necessary, adjust the unit (centimeters or inches).")
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case cm = "cm"
    case inches = "inches"
    
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
