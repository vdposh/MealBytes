//
//  DailyIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct DailyIntakeView: View {
    @FocusState private var macronutrientsFocused: MacronutrientsFocus?
    @FocusState private var caloriesFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let macroOrder: [MacronutrientsFocus] = [
        .fat,
        .carbohydrate,
        .protein
    ]
    
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        dailyIntakeViewContentBody
            .navigationBarTitle("Daily Intake")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                dailyIntakeViewToolbar
            }
            .alert(isPresented: $dailyIntakeViewModel.showAlert) {
                dailyIntakeViewAlert
            }
            .onChange(of: macronutrientsFocused) {
                handleFocusLoss(macronutrientsFocused)
            }
    }
    
    private var dailyIntakeViewContentBody: some View {
        Form {
            OverviewDailyIntakeSection(
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            CalorieMetricsSection(
                focus: $caloriesFocused,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            MacronutrientMetricsSection(
                focus: _macronutrientsFocused,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            NutrientsToggleSection(toggleOn: $dailyIntakeViewModel.toggleOn)
        }
    }
    
    @ToolbarContentBuilder
    private var dailyIntakeViewToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            buildKeyboardToolbar(
                current: macronutrientsFocused,
                ordered: macroOrder,
                set: { macronutrientsFocused = $0 },
                normalize: dailyIntakeViewModel.normalizeInputs,
                extraDone: { caloriesFocused = false }
            )
        }
        
        ToolbarItem {
            Button(role: .confirm) {
                if dailyIntakeViewModel.handleDailyIntakeSave() {
                    Task {
                        await dailyIntakeViewModel.saveDailyIntakeView()
                    }
                    
                    dismiss()
                }
                
                caloriesFocused = false
                macronutrientsFocused = nil
                dailyIntakeViewModel.normalizeInputs()
            }
        }
    }
    
    private var dailyIntakeViewAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text(dailyIntakeViewModel.alertMessage),
            dismissButton: .default(Text("OK")) {
                dailyIntakeViewModel.showAlert = false
            }
        )
    }
    
    private func handleFocusLoss(_ focus: MacronutrientsFocus?) {
        guard let focus else { return }
        
        dailyIntakeViewModel.handleMacronutrientsFocusChange(
            focus: focus,
            didGainFocus: false
        )
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
