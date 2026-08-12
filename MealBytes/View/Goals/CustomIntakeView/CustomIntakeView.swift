//
//  CustomIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

struct CustomIntakeView: View {
    @FocusState private var focus: Bool
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var customIntakeViewModel: CustomIntakeViewModel
    
    var body: some View {
        Form {
            Section {
                ServingTextFieldView(
                    text: $customIntakeViewModel.calories,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 5
                )
                .focused($focus)
            } header: {
                Text("Calories")
                    .foregroundStyle(
                        customIntakeViewModel.calories.isValidNumericInput()
                        ? .secondary
                        : Color.customRed
                    )
            } footer: {
                Text("Enter your daily calorie intake directly.")
            }
        }
        .navigationTitle("Custom Intake")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    if customIntakeViewModel.isValid {
                        customIntakeViewModel.saveCustomIntake()
                        dismiss()
                    }
                    
                    focus = false
                    customIntakeViewModel.normalizeCalories()
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if focus {
                KeyboardToolbarView(
                    done: {
                        focus = false
                        customIntakeViewModel.normalizeCalories()
                    }
                )
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
