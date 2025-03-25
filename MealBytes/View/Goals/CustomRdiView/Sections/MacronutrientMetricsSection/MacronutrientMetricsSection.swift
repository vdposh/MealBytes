//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    var isFatFocused: FocusState<Bool>.Binding
    var isCarbohydrateFocused: FocusState<Bool>.Binding
    var isProteinFocused: FocusState<Bool>.Binding
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            VStack {
                Text("Required Macronutrient Metrics")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 5)
                
                VStack(spacing: 15) {
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.fat,
                        value: customRdiViewModel.oppositeValue(
                            for: customRdiViewModel.fat, factor: 9),
                        unitRight: customRdiViewModel.unitSymbol(
                            inverted: true),
                        unitLeft: customRdiViewModel.unitSymbol(),
                        title: "Fat",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.fat),
                        focusedField: isFatFocused
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.carbohydrate,
                        value: customRdiViewModel.oppositeValue(
                            for: customRdiViewModel.carbohydrate, factor: 4),
                        unitRight: customRdiViewModel.unitSymbol(
                            inverted: true),
                        unitLeft: customRdiViewModel.unitSymbol(),
                        title: "Carbohydrate",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.carbohydrate),
                        focusedField: isCarbohydrateFocused
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.protein,
                        value: customRdiViewModel.oppositeValue(
                            for: customRdiViewModel.protein, factor: 4),
                        unitRight: customRdiViewModel.unitSymbol(
                            inverted: true),
                        unitLeft: customRdiViewModel.unitSymbol(),
                        title: "Protein",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.protein),
                        focusedField: isProteinFocused
                    )
                }
                .padding(.top, 5)
                .padding(.bottom, 10)
                
                HStack {
                    Button(action: {
                        customRdiViewModel.togglePercentageMode()
                    }) {
                        Text(customRdiViewModel.toggleButtonText)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.customGreen)
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.bottom, 5)
                }
            }
        }
    }
}
