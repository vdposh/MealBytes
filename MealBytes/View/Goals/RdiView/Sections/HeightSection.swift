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
            .id("heightField")
        } header: {
            Text("Height Details")
        } footer: {
            Text("Enter height and, if necessary, adjust the unit (centimeters or inches).")
        }
        
        Section {
            Text("RDI is an estimate and not medical advice.\nMealBytes")
                .font(.caption)
                .foregroundStyle(.secondary)
                .opacity(0.6)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .listRowBackground(Color.clear)
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case cm = "cm"
    case inches = "inches"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        default:
            return .customGreen
        }
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)

    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
