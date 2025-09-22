//
//  DailyIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct DailyIntakeView: View {
    @FocusState private var focusMacronutrients: MacronutrientsFocus?
    @FocusState private var caloriesFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let macroOrder: [MacronutrientsFocus] = [
        .fat,
        .carbohydrate,
        .protein
    ]
    
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        List {
            OverviewDailyIntakeSection(
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            
            CalorieMetricsSection(
                isFocused: $caloriesFocused,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            .disabled(dailyIntakeViewModel.toggleOn)
            
            MacronutrientMetricsSection(
                focusedField: _focusMacronutrients,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            
            NutrientsToggleSection(
                toggleOn: $dailyIntakeViewModel.toggleOn
            )
        }
        .navigationBarTitle("Daily Intake", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                buildKeyboardToolbar(
                    current: focusMacronutrients,
                    ordered: macroOrder,
                    set: { focusMacronutrients = $0 },
                    normalize: dailyIntakeViewModel.normalizeInputs,
                    extraDone: { caloriesFocused = false }
                )
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    if dailyIntakeViewModel.handleSave() {
                        Task {
                            await dailyIntakeViewModel
                                .saveDailyIntakeView()
                        }
                        dismiss()
                    }
                    caloriesFocused = false
                    focusMacronutrients = nil
                    dailyIntakeViewModel.normalizeInputs()
                }
            }
        }
        .onChange(of: focusMacronutrients) {
            if let focusMacronutrients {
                dailyIntakeViewModel
                    .handleMacronutrientFocusChange(
                        focus: focusMacronutrients,
                        didGainFocus: false
                    )
            }
        }
        .alert(
            "Error",
            isPresented: $dailyIntakeViewModel.showAlert
        ) {
            Button("OK") {
                dailyIntakeViewModel.showAlert = false
            }
        } message: {
            Text(dailyIntakeViewModel.alertMessage)
        }
    }
}

enum MacronutrientsFocus: Hashable {
    case fat
    case carbohydrate
    case protein
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
