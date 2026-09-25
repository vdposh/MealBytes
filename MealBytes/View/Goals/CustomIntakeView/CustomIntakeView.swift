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
        customIntakeViewBody
            .navigationTitle(IntakeSource.custom.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
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
                buildKeyboardToolbar(
                    current: focus,
                    ordered: focusOrder,
                    normalize: customIntakeViewModel.normalizeInputs,
                    set: { focus = $0 }
                )
            }
            .ignoresSafeArea(edges: focus != nil ? [] : .bottom)
    }
    
    private var customIntakeViewBody: some View {
        Form {
            Section {
                ServingTextFieldView(
                    text: $customIntakeViewModel.calories,
                    labelIconName: "flame.fill",
                    labelIconColor: .customCalories,
                    stackText: NutrientType.calories.title,
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 5
                )
                .focused($focus, equals: .calories)
                
                ServingTextFieldView(
                    text: $customIntakeViewModel.fat,
                    labelIconName: "f.circle.fill",
                    labelIconColor: .customFat,
                    stackText: NutrientType.fat.title,
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus, equals: .fat)
                
                ServingTextFieldView(
                    text: $customIntakeViewModel.carbohydrate,
                    labelIconName: "c.circle.fill",
                    labelIconColor: .customCarbs,
                    stackText: NutrientType.carbohydrate.title,
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus, equals: .carbohydrate)
                
                ServingTextFieldView(
                    text: $customIntakeViewModel.protein,
                    labelIconName: "p.circle.fill",
                    labelIconColor: .customProtein,
                    stackText: NutrientType.protein.title,
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus, equals: .protein)
            } footer: {
                Text("Enter values directly")
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
