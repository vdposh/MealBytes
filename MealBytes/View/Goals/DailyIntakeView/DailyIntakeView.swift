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
            .navigationTitle(IntakeSource.macros.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                dailyIntakeViewToolbar
            }
            .safeAreaInset(edge: .bottom) {
                if caloriesFocused || macronutrientsFocused != nil {
                    buildKeyboardToolbar(
                        current: macronutrientsFocused,
                        ordered: macroOrder,
                        normalize: dailyIntakeViewModel.normalizeInputs,
                        set: { macronutrientsFocused = $0 },
                        extraDone: { caloriesFocused = false }
                    )
                }
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
            MacronutrientMetricsSection(
                focus: _macronutrientsFocused,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
        }
    }
    
    @ToolbarContentBuilder
    private var dailyIntakeViewToolbar: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                Task {
                    await dailyIntakeViewModel.saveDailyIntakeView()
                }
                
                caloriesFocused = false
                macronutrientsFocused = nil
                dailyIntakeViewModel.normalizeInputs()
                dismiss()
            }
            .disabled(!dailyIntakeViewModel.isValid)
        }
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
