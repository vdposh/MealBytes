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
        VStack(alignment: .leading) {
            Text("WEIGHT DETAILS")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
            VStack {
                ServingTextFieldView(
                    text: $rdiViewModel.weight,
                    title: "Weight",
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.weight
                    ),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .weight)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                HStack {
                    Text("Weight Unit")
                        .padding(.leading, 20)
                    
                    Picker("Weight Unit",
                           selection: $rdiViewModel.selectedWeightUnit) {
                        if rdiViewModel.selectedWeightUnit == .notSelected {
                            Text("Not Selected").tag(WeightUnit.notSelected)
                        }
                        ForEach(
                            WeightUnit.allCases.filter { $0 != .notSelected },
                            id: \.self
                        ) { weight in
                            Text(weight.rawValue).tag(weight)
                        }
                    }
                           .pickerStyle(.menu)
                           .accentColor(
                            rdiViewModel.selectedWeightUnit.accentColor
                           )
                           .frame(maxWidth: .infinity, alignment: .trailing)
                           .padding(.trailing, 10)
                }
                .padding(.top, 2)
                .padding(.bottom, 10)
            }
            
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .id("weightField")
            
            Text("Enter weight and adjust the unit as needed (kilograms or pounds).")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 25)
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
