//
//  GoalsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @FocusState private var customFocus: CustomIntakeFocus?
    @FocusState private var macrosFocus: MacronutrientsFocus?
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    private let customOrder: [CustomIntakeFocus] = [
        .calories, .fat, .carbohydrate, .protein
    ]
    
    private let macrosOrder: [MacronutrientsFocus] = [
        .fat, .carbohydrate, .protein
    ]
    
    var body: some View {
        Form {
            goalsViewBuilder
            intakeSourceSection
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    Task {
                        await goalsViewModel.saveSelected()
                    }
                    
                    dismiss()
                }
                .disabled(!goalsViewModel.isSelectedValid)
            }
        }
        .safeAreaInset(edge: .bottom) {
            switch goalsViewModel.selectedIntakeSource {
            case .custom:
                buildKeyboardToolbar(
                    current: customFocus,
                    ordered: customOrder,
                    normalize: goalsViewModel.normalizeSelected,
                    set: { customFocus = $0 }
                )
            case .macros:
                buildKeyboardToolbar(
                    current: macrosFocus,
                    ordered: macrosOrder,
                    normalize: goalsViewModel.normalizeSelected,
                    set: { macrosFocus = $0 }
                )
            case .personal:
                EmptyView()
            }
        }
        .ignoresSafeArea(edges: ignoreBottomSafeArea ? .bottom : [])
    }
    
    private var intakeSourceSection: some View {
        Section {
            NavigationLink {
                IntakeSourceView(goalsViewModel: goalsViewModel)
            } label: {
                LabeledContent {
                    Text(goalsViewModel.selectedIntakeSource.title)
                } label: {
                    Text("Goal Type")
                }
            }
        }
    }
    
    @ViewBuilder
    private var goalsViewBuilder: some View {
        switch goalsViewModel.selectedIntakeSource {
        case .personal:
            if let personalIntakeViewModel = goalsViewModel
                .personalIntakeViewModel as? PersonalIntakeViewModel {
                PersonalIntakeView(
                    personalIntakeViewModel: personalIntakeViewModel
                )
            }
        case .macros:
            if let macrosIntakeViewModel = goalsViewModel
                .macrosIntakeViewModel as? MacrosIntakeViewModel {
                MacrosIntakeView(
                    focus: $macrosFocus,
                    macrosIntakeViewModel: macrosIntakeViewModel
                )
            }
        case .custom:
            if let customIntakeViewModel = goalsViewModel
                .customIntakeViewModel as? CustomIntakeViewModel {
                CustomIntakeView(
                    customIntakeViewModel: customIntakeViewModel,
                    focus: $customFocus
                )
            }
        }
    }
    
    private var ignoreBottomSafeArea: Bool {
        switch goalsViewModel.selectedIntakeSource {
        case .personal:
            return false
        case .custom:
            return customFocus == nil
        case .macros:
            return macrosFocus == nil
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
