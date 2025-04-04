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
                        Text("Calculate your daily calorie intake by distributing macronutrients (fats, carbohydrates, and proteins) in percentages or grams, depending on your preference.")
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
                    MacronutrientMetricsSection(
                        focusedField: _focusedField,
                        customRdiViewModel: customRdiViewModel
                    )
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
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if let errorMessage = customRdiViewModel
                                .validateInputs(includePercentageCheck: true) {
                                customRdiViewModel.displayErrorAlert(
                                    with: errorMessage)
                            } else {
                                Task {
                                    await customRdiViewModel.saveCustomRdiView()
                                }
                                dismiss()
                            }
                        }
                    }
                }
                .alert(customRdiViewModel.alertTitle,
                       isPresented: $customRdiViewModel.showAlert) {
                    Button("OK", role: .none) {
                        customRdiViewModel.showAlert = false
                    }
                } message: {
                    Text(customRdiViewModel.alertMessage)
                }
            }
        }
        .task {
            await customRdiViewModel.loadCustomRdiView()
            await MainActor.run {
                customRdiViewModel.isLoading = false
            }
        }
    }
}
