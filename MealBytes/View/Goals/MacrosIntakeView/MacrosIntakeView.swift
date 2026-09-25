//
//  MacrosIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct MacrosIntakeView: View {
    @FocusState private var macronutrientsFocused: MacronutrientsFocus?
    @Environment(\.dismiss) private var dismiss
    
    private let macroOrder: [MacronutrientsFocus] = [
        .fat,
        .carbohydrate,
        .protein
    ]
    
    @ObservedObject var macrosIntakeViewModel: MacrosIntakeViewModel
    
    var body: some View {
        macrosIntakeViewContentBody
            .navigationTitle(IntakeSource.macros.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                macrosIntakeViewToolbar
            }
            .safeAreaInset(edge: .bottom) {
                buildKeyboardToolbar(
                    current: macronutrientsFocused,
                    ordered: macroOrder,
                    normalize: macrosIntakeViewModel.normalizeInputs,
                    set: { macronutrientsFocused = $0 }
                )
            }
            .ignoresSafeArea(
                edges: macronutrientsFocused != nil ? [] : .bottom
            )
            .onChange(of: macronutrientsFocused) {
                handleFocusLoss(macronutrientsFocused)
            }
    }
    
    private var macrosIntakeViewContentBody: some View {
        Form {
            MacrosMetricsSection(
                focus: _macronutrientsFocused,
                macrosIntakeViewModel: macrosIntakeViewModel
            )
        }
    }
    
    @ToolbarContentBuilder
    private var macrosIntakeViewToolbar: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                Task {
                    await macrosIntakeViewModel.saveMacrosIntakeView()
                }
                
                macronutrientsFocused = nil
                macrosIntakeViewModel.normalizeInputs()
                dismiss()
            }
            .disabled(!macrosIntakeViewModel.isValid)
        }
    }
    
    private func handleFocusLoss(_ focus: MacronutrientsFocus?) {
        guard let focus else { return }
        
        macrosIntakeViewModel.handleMacronutrientsFocusChange(
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
    PreviewMacrosIntakeView.macrosIntakeView
}
