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
    
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                OverviewDailyIntakeSection()
                
                CalorieMetricsSection(
                    isFocused: $caloriesFocused,
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .disabled(dailyIntakeViewModel.toggleOn)
                
                if dailyIntakeViewModel.toggleOn {
                    MacronutrientMetricsSection(
                        focusedField: _focusMacronutrients,
                        dailyIntakeViewModel: dailyIntakeViewModel
                    )
                }
                
                NutrientsToggleSection(
                    toggleOn: $dailyIntakeViewModel.toggleOn
                )
            }
            .navigationBarTitle("Daily Intake", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    KeyboardToolbarView(
                        showArrows: true,
                        canMoveUp: canMoveFocus(.up),
                        canMoveDown: canMoveFocus(.down),
                        moveUp: { moveFocus(.up) },
                        moveDown: { moveFocus(.down) },
                        done: {
                            caloriesFocused = false
                            focusMacronutrients = nil
                            dailyIntakeViewModel.normalizeInputs()
                        }
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
            .onChange(of: focusMacronutrients) {
                guard let field = focusMacronutrients else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        proxy.scrollTo(
                            field.scrollID,
                            anchor: field.scrollAnchor
                        )
                    }
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
    
    // MARK: - Keyboard
    private func moveFocus(_ direction: FocusDirection) {
        guard canMoveFocus(direction) else { return }
        switch direction {
        case .up:
            switch focusMacronutrients {
            case .carbohydrate: focusMacronutrients = .fat
            case .protein: focusMacronutrients = .carbohydrate
            default: break
            }
        case .down:
            switch focusMacronutrients {
            case .fat: focusMacronutrients = .carbohydrate
            case .carbohydrate: focusMacronutrients = .protein
            case .protein: focusMacronutrients = nil
            default: break
            }
        }
    }
    
    private func canMoveFocus(_ direction: FocusDirection) -> Bool {
        guard let focus = focusMacronutrients else { return false }
        switch direction {
        case .up: return focus != .fat
        case .down: return focus != .protein
        }
    }
    
    private enum FocusDirection {
        case up
        case down
    }
}

enum MacronutrientsFocus: Hashable {
    case fat
    case carbohydrate
    case protein
    
    var scrollID: String {
        switch self {
        default: "macronutrientsField"
        }
    }
    
    var scrollAnchor: UnitPoint {
        switch self {
        default: .top
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
