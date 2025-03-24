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
    @ObservedObject var viewModel: CustomRdiViewModel
    
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
                        textFieldBinding: $viewModel.fat,
                        value: viewModel.oppositeValue(
                            for: viewModel.fat, factor: 9),
                        unitRight: viewModel.unitSymbol(inverted: true),
                        unitLeft: viewModel.unitSymbol(inverted: false),
                        title: "Fat",
                        titleColor: viewModel.titleColor(
                            for: viewModel.fat),
                        focusedField: isFatFocused
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $viewModel.carbohydrate,
                        value: viewModel.oppositeValue(
                            for: viewModel.carbohydrate, factor: 4),
                        unitRight: viewModel.unitSymbol(inverted: true),
                        unitLeft: viewModel.unitSymbol(inverted: false),
                        title: "Carbohydrate",
                        titleColor: viewModel.titleColor(
                            for: viewModel.carbohydrate),
                        focusedField: isCarbohydrateFocused
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $viewModel.protein,
                        value: viewModel.oppositeValue(
                            for: viewModel.protein, factor: 4),
                        unitRight: viewModel.unitSymbol(inverted: true),
                        unitLeft: viewModel.unitSymbol(inverted: false),
                        title: "Protein",
                        titleColor: viewModel.titleColor(
                            for: viewModel.protein),
                        focusedField: isProteinFocused
                    )
                }
                .padding(.top, 5)
                .padding(.bottom, 10)
                
                HStack {
                    Button(action: { viewModel.togglePercentageMode() }) {
                        Text(viewModel.toggleButtonText)
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
