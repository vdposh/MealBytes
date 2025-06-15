//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    @FocusState var focusedField: MacronutrientsFocus?
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 15) {
                MacronutrientRow(
                    textFieldBinding: $customRdiViewModel.fat,
                    focusedField: $focusedField,
                    title: "Fat",
                    titleColor: customRdiViewModel.titleColor(
                        for: customRdiViewModel.fat),
                    customRdiViewModel: customRdiViewModel
                )
                .focused($focusedField, equals: .fat)
                
                MacronutrientRow(
                    textFieldBinding: $customRdiViewModel.carbohydrate,
                    focusedField: $focusedField,
                    title: "Carbohydrate",
                    titleColor: customRdiViewModel.titleColor(
                        for: customRdiViewModel.carbohydrate),
                    customRdiViewModel: customRdiViewModel
                )
                .focused($focusedField, equals: .carbohydrate)
                
                MacronutrientRow(
                    textFieldBinding: $customRdiViewModel.protein,
                    focusedField: $focusedField,
                    title: "Protein",
                    titleColor: customRdiViewModel.titleColor(
                        for: customRdiViewModel.protein),
                    customRdiViewModel: customRdiViewModel
                )
                .focused($focusedField, equals: .protein)
            }
            .padding(.bottom, 5)
        } header: {
            Text("Macronutrient Metrics")
        } footer: {
            Text("Enter values for macronutrients. These inputs will be used to precisely calculate daily calorie intake.")
        }
    }
}

enum MacronutrientsFocus: Hashable {
    case fat, carbohydrate, protein
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
