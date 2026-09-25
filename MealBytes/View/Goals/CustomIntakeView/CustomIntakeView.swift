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
                NutrientFieldRow(
                    type: .calories,
                    text: $customIntakeViewModel.calories,
                    focus: $focus,
                    focusCase: .calories,
                    maxIntegerDigits: 5
                )
                
                NutrientFieldRow(
                    type: .fat,
                    text: $customIntakeViewModel.fat,
                    focus: $focus,
                    focusCase: .fat
                )
                
                NutrientFieldRow(
                    type: .carbohydrate,
                    text: $customIntakeViewModel.carbohydrate,
                    focus: $focus,
                    focusCase: .carbohydrate
                )
                
                NutrientFieldRow(
                    type: .protein,
                    text: $customIntakeViewModel.protein,
                    focus: $focus,
                    focusCase: .protein
                )
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
