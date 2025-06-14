//
//  CustomRdiView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct CustomRdiView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusCalories: CustomRdiFocus?
    @FocusState private var focusMacronutrients: MacronutrientsFocus?
    @StateObject private var customRdiViewModel = CustomRdiViewModel()
    
    var body: some View {
        ZStack {
            if customRdiViewModel.isLoading {
                LoadingView()
            } else {
                List {
                    Section {
                    } footer: {
                        Text("Set RDI by entering calories directly or calculate it based on macronutrient distribution.")
                    }
                    
                    CalorieMetricsSection(
                        focusedField: _focusCalories,
                        customRdiViewModel: customRdiViewModel
                    )
                    .disabled(customRdiViewModel.toggleOn)
                    
                    if customRdiViewModel.toggleOn {
                        MacronutrientMetricsSection(
                            focusedField: _focusMacronutrients,
                            customRdiViewModel: customRdiViewModel
                        )
                    }
                    
                    Section {
                        Toggle(isOn: $customRdiViewModel.toggleOn) {
                            Text("Macronutrient metrics")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .customGreen))
                    } footer: {
                        Text("Enable this option to calculate intake using macronutrients.")
                    }
                }
                .scrollDismissesKeyboard(.never)
                .navigationBarTitle("Custom RDI", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack(spacing: 0) {
                            if focusMacronutrients != nil {
                                Button {
                                    moveFocus(.up)
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .foregroundColor(colorForFocus(
                                            isActive: canMoveFocus(.up)))
                                }
                                .disabled(!canMoveFocus(.up))
                                
                                Button {
                                    moveFocus(.down)
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(colorForFocus(
                                            isActive: canMoveFocus(.down)))
                                }
                                .disabled(!canMoveFocus(.down))
                            } else if focusCalories != nil {
                                Text("Calories")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Button("Done") {
                            focusCalories = nil
                            focusMacronutrients = nil
                        }
                        .font(.headline)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if customRdiViewModel.handleSave() {
                                Task {
                                    await customRdiViewModel.saveCustomRdiView()
                                }
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
        .alert("Error", isPresented: $customRdiViewModel.showAlert) {
            Button("OK", role: .none) {
                customRdiViewModel.showAlert = false
            }
        } message: {
            Text(customRdiViewModel.alertMessage)
        }
        .task {
            await customRdiViewModel.loadCustomRdiView()
        }
    }
    
    // MARK: - Keyboard
    private func moveFocus(_ direction: FocusDirection) {
        guard canMoveFocus(direction) else { return }
        switch direction {
        case .up:
            switch focusMacronutrients {
            case .carbohydrate:
                focusMacronutrients = .fat
            case .protein:
                focusMacronutrients = .carbohydrate
            default:
                break
            }
        case .down:
            switch focusMacronutrients {
            case .fat:
                focusMacronutrients = .carbohydrate
            case .carbohydrate:
                focusMacronutrients = .protein
            case .protein:
                focusMacronutrients = nil
            default:
                break
            }
        }
    }
    
    private func canMoveFocus(_ direction: FocusDirection) -> Bool {
        guard let focus = focusMacronutrients else { return false }
        switch direction {
        case .up:
            return focus != .fat
        case .down:
            return focus != .protein
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

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
