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
    
    @StateObject private var viewModel: GoalsViewModel
    
    init(viewModel: GoalsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private func dismissAllFocuses() {
        isCaloriesFocused = false
        isFatFocused = false
        isCarbohydrateFocused = false
        isProteinFocused = false
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
                        }
                    }
                }
            }
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .none) {
                viewModel.isShowingAlert = false
            }
        }
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
