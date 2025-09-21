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
            VStack(spacing: 20) {
                ServingTextFieldView(
                    text: $rdiViewModel.height,
                    title: "Height",
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.height
                    ),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .height)
                
                Picker(
                    "Height Unit",
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
                .pickerStyle(.menu)
                .tint(rdiViewModel.selectedHeightUnit.selectedColor)
            }
        } footer: {
            Text("Enter height and, if necessary, adjust the unit (centimeters or inches).")
                .padding(.bottom)
        }
        .padding(.vertical, 4)
        .id("heightField")
    }
}

enum HeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case cm = "cm"
    case inches = "inches"
    
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
