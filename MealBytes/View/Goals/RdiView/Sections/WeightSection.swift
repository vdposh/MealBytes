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
        SectionStyleContainer(
            mainContent: {
                ServingTextFieldView(
                    text: $rdiViewModel.weight,
                    title: "Weight",
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.weight
                    ),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .weight)
            },
            secondaryContent: {
                AnyView(
                    HStack {
                        Text("Weight Unit")
                        
                        Picker("Weight Unit",
                               selection: $rdiViewModel.selectedWeightUnit
                        ) {
                            if rdiViewModel.selectedWeightUnit == .notSelected {
                                Text("Not Selected").tag(WeightUnit.notSelected)
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
                        .accentColor(
                            rdiViewModel.selectedWeightUnit.accentColor
                        )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                )
            },
            layout: .pickerUnitStyle,
            title: "Weight Details",
            description: "Enter weight and adjust the unit as needed (kilograms or pounds)."
        )
        .id("weightField")
    }
}

enum WeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case kg = "kg"
    case lbs = "lbs"
    
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
