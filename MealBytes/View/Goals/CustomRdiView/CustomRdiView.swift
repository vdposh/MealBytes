//
//  CustomRdiView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct CustomRdiView: View {
    @FocusState private var isCaloriesFocused: Bool
    @FocusState private var isFatFocused: Bool
    @FocusState private var isCarbohydrateFocused: Bool
    @FocusState private var isProteinFocused: Bool
    @State private var isSaveSuccessAlertPresented: Bool = false
    
    @StateObject private var customRdiViewModel: CustomRdiViewModel
    
    init(customRdiViewModel: CustomRdiViewModel) {
        _customRdiViewModel = StateObject(wrappedValue: customRdiViewModel)
    }
    
    var body: some View {
        ZStack {
            if customRdiViewModel.isLoading {
                LoadingView()
            } else {
                List {
                    CalorieMetricsSection(
                        isCaloriesFocused: $isCaloriesFocused,
                        customRdiViewModel: customRdiViewModel
                    )
                    MacronutrientMetricsSection(
                        isFatFocused: $isFatFocused,
                        isCarbohydrateFocused: $isCarbohydrateFocused,
                        isProteinFocused: $isProteinFocused,
                        customRdiViewModel: customRdiViewModel
                    )
                    
                    Section {
                        Text("Calculate your daily calorie intake by entering the total number of calories and distributing macronutrients such as fats, carbohydrates, and proteins in percentages. Alternatively, you can switch to grams and specify the required amounts for each macronutrient to calculate the total calorie amount.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Fill in the data and press Save")
                            .lineLimit(1)
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listSectionSpacing(15)
                .scrollDismissesKeyboard(.never)
                .navigationBarTitle("Custom RDI", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Text("Enter value")
                            .foregroundColor(.secondary)
                        Button("Done") {
                            dismissAllFocuses()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if let errorMessage = customRdiViewModel
                                .validateInputs(includePercentageCheck: true) {
                                customRdiViewModel.showAlert(
                                    message: errorMessage)
                            } else {
                                Task {
                                    await customRdiViewModel.saveCustomRdiView()
                                    dismissAllFocuses()
                                    isSaveSuccessAlertPresented = true
                                }
                            }
                        }
                    }
                }
                .alert("Invalid value",
                       isPresented: $customRdiViewModel.isShowingAlert) {
                    Button("OK", role: .none) {
                        customRdiViewModel.isShowingAlert = false
                    }
                } message: {
                    Text(customRdiViewModel.alertMessage)
                }
                .alert("Done", isPresented: $isSaveSuccessAlertPresented) {
                    Button("OK", role: .none) {
                        isSaveSuccessAlertPresented = false
                    }
                } message: {
                    Text("Your goals have been saved successfully!")
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
    
    private func dismissAllFocuses() {
        isCaloriesFocused = false
        isFatFocused = false
        isCarbohydrateFocused = false
        isProteinFocused = false
    }
}

#Preview {
    CustomRdiView(customRdiViewModel: CustomRdiViewModel(
        firestoreManager: FirestoreManager())
    )
    .accentColor(.customGreen)
}
