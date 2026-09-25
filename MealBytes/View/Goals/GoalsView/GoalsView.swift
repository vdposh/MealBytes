//
//  GoalsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    @FocusState private var customFocus: CustomIntakeFocus?
    @FocusState private var macrosFocus: MacronutrientsFocus?
    @Environment(\.dismiss) private var dismiss
    
    private let customOrder: [CustomIntakeFocus] = [
        .calories, .fat, .carbohydrate, .protein
    ]
    
    private let macrosOrder: [MacronutrientsFocus] = [
        .fat, .carbohydrate, .protein
    ]
    
    var body: some View {
        Form {
            Section {
                ForEach(IntakeSource.allCases, id: \.self) { source in
                    SelectionRow(
                        title: source.rawValue,
                        description: source.description,
                        isSelected: goalsViewModel
                            .selectedIntakeSource == source
                    ) {
                        goalsViewModel.selectSource(source)
                    }
                }
            }
            
            goalsViewModel.view(
                for: goalsViewModel.selectedIntakeSource,
                customFocus: $customFocus,
                macrosFocus: $macrosFocus
            )
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
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
        .task {
            await goalsViewModel.loadGoalsData()
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

enum IntakeSource: String, CaseIterable {
    case personal = "Personal"
    case macros = "Macros"
    case custom = "Custom"
    
    var description: String {
        switch self {
        case .personal:
            return "Set goal based on body parameters"
        case .macros:
            return "Calculated from macronutrients"
        case .custom:
            return "Direct entry"
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
