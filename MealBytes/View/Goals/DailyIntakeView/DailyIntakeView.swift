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
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            ScrollViewReader { proxy in
                ScrollView {
                    OverviewDailyIntakeSection(
                        dailyIntakeViewModel: dailyIntakeViewModel
                    )
                    
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
                        HStack(spacing: 0) {
                            if focusMacronutrients != nil {
                                Button {
                                    moveFocus(.up)
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .foregroundColor(
                                            colorForFocus(
                                                isActive: canMoveFocus(.up)
                                            )
                                        )
                                }
                                .disabled(!canMoveFocus(.up))
                                
                                Button {
                                    moveFocus(.down)
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(
                                            colorForFocus(
                                                isActive: canMoveFocus(.down)
                                            )
                                        )
                                }
                                .disabled(!canMoveFocus(.down))
                            }
                        }
                        
                        DoneButtonView {
                            caloriesFocused = false
                            focusMacronutrients = nil
                            dailyIntakeViewModel.normalizeInputs()
                        }
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
    
    private func colorForFocus(isActive: Bool) -> Color {
        isActive ? .customGreen : .secondary
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
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    return NavigationStack {
        DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
    }
}
