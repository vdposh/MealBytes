//
//  CustomIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

struct CustomIntakeView: View {
    @FocusState private var focus: CustomIntakeFocus?
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var customIntakeViewModel: CustomIntakeViewModel
    
    private let focusOrder: [CustomIntakeFocus] = [
        .calories,
        .fat,
        .carbohydrate,
        .protein
    ]
    
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
                .focused($focus, equals: .calories)
                
                ServingTextFieldView(
                    text: $customIntakeViewModel.fat,
                    stackText: "Fat",
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus, equals: .fat)
                
                ServingTextFieldView(
                    text: $customIntakeViewModel.carbohydrate,
                    stackText: "Carbohydrate",
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus, equals: .carbohydrate)
                
                ServingTextFieldView(
                    text: $customIntakeViewModel.protein,
                    stackText: "Protein",
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus, equals: .protein)
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
                    
                    focus = nil
                    customIntakeViewModel.normalizeInputs()
                }
                .disabled(!customIntakeViewModel.isValid)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if focus != nil {
                buildKeyboardToolbar(
                    current: focus,
                    ordered: focusOrder,
                    normalize: customIntakeViewModel.normalizeInputs,
                    set: { focus = $0 }
                )
            }
        }
    }
}

enum CustomIntakeFocus: Hashable {
    case calories
    case fat
    case carbohydrate
    case protein
}

#Preview {
    PreviewContentView.contentView
}
