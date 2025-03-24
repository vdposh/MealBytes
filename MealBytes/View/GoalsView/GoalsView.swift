//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 22/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @FocusState private var isCaloriesFocused: Bool
    @FocusState private var isFatFocused: Bool
    @FocusState private var isCarbohydrateFocused: Bool
    @FocusState private var isProteinFocused: Bool
    @State private var isSaveSuccessAlertPresented: Bool = false
    
    @StateObject private var viewModel: GoalsViewModel
    
    init(viewModel: GoalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            CalorieMetricsSection(
                isCaloriesFocused: $isCaloriesFocused,
                viewModel: viewModel
            )
            MacronutrientMetricsSection(
                isFatFocused: $isFatFocused,
                isCarbohydrateFocused: $isCarbohydrateFocused,
                isProteinFocused: $isProteinFocused,
                viewModel: viewModel
            )
        }
        .listRowSeparator(.hidden)
        .listSectionSpacing(15)
        .scrollDismissesKeyboard(.never)
        .navigationBarTitle("Your Goal", displayMode: .inline)
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
                    if let errorMessage = viewModel.validateInputs(includePercentageCheck: true) {
                        viewModel.showAlert(message: errorMessage)
                    } else {
                        Task {
                            await viewModel.saveGoalsViewModel()
                            dismissAllFocuses()
                            isSaveSuccessAlertPresented = true
                        }
                    }
                }
            }
        }
        .alert("Invalid value", isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .none) {
                viewModel.isShowingAlert = false
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .alert("Done", isPresented: $isSaveSuccessAlertPresented) {
            Button("OK", role: .none) {
                isSaveSuccessAlertPresented = false
            }
        } message: {
            Text("Your goals have been saved successfully!")
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
    TabBarView(
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel(
            firestoreManager: FirestoreManager()
        )
    )
    .accentColor(.customGreen)
}
