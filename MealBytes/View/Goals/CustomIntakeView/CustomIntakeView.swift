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
                    stackText: "Calories",
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 5
                )
                .focused($focus)
            } footer: {
                Text(IntakeSource.custom.description)
            }
        }
        .navigationTitle(IntakeSource.custom.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    if customIntakeViewModel.isValid {
                        Task {
                            await customIntakeViewModel.saveCustomIntake()
                        }
                        
                        dismiss()
                    }
                    
                    focus = false
                    customIntakeViewModel.normalizeCalories()
                }
                .disabled(!customIntakeViewModel.isValid)
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
