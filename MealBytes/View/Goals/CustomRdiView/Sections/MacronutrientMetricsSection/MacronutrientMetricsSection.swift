//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    @FocusState var focusedField: Bool
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section(header: Text("Macronutrient Metrics")) {
            VStack {
                VStack(spacing: 15) {
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.fat,
                        focusedField: _focusedField,
                        value: customRdiViewModel.oppositeValue(
                            for: customRdiViewModel.fat, factor: 9),
                        unitRight: customRdiViewModel.unitSymbol(
                            inverted: true),
                        unitLeft: customRdiViewModel.unitSymbol(),
                        title: "Fat",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.fat)
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.carbohydrate,
                        focusedField: _focusedField,
                        value: customRdiViewModel.oppositeValue(
                            for: customRdiViewModel.carbohydrate, factor: 4),
                        unitRight: customRdiViewModel.unitSymbol(
                            inverted: true),
                        unitLeft: customRdiViewModel.unitSymbol(),
                        title: "Carbohydrate",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.carbohydrate)
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.protein,
                        focusedField: _focusedField,
                        value: customRdiViewModel.oppositeValue(
                            for: customRdiViewModel.protein, factor: 4),
                        unitRight: customRdiViewModel.unitSymbol(
                            inverted: true),
                        unitLeft: customRdiViewModel.unitSymbol(),
                        title: "Protein",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.protein)
                    )
                }
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
