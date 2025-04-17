//
//  CustomRdiView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct CustomRdiView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Bool
    @StateObject private var customRdiViewModel = CustomRdiViewModel()
    
    var body: some View {
        ZStack {
            if customRdiViewModel.isLoading {
                LoadingView()
            } else {
                List {
                    Section {
                        Text("Set your daily RDI by entering calories directly or calculate it using macronutrient distribution (fats, carbohydrates, and proteins).")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    
                    CalorieMetricsSection(
                        focusedField: _focusedField,
                        customRdiViewModel: customRdiViewModel
                    )
                    .disabled(customRdiViewModel.toggleOn)
                    
                    if customRdiViewModel.toggleOn {
                        MacronutrientMetricsSection(
                            focusedField: _focusedField,
                            customRdiViewModel: customRdiViewModel
                        )
                    }
                    
                    Section {
                        Toggle(isOn: $customRdiViewModel.toggleOn) {
                            Text("Macronutrient metrics")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .customGreen))
                    } header: {
                        Text("Macronutrients Overview")
                    } footer: {
                        Text("Enable this option to calculate your intake using macronutrients (fats, carbohydrates, and proteins).")
                    }
                }
                .listSectionSpacing(15)
                .scrollDismissesKeyboard(.never)
                .navigationBarTitle("Custom RDI", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Text("Enter value")
                            .foregroundColor(.secondary)
                        Button("Done") {
                            focusedField = false
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
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
