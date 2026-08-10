//
//  MeasurementSelectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.08.2026.
//

import SwiftUI

struct MeasurementSelectionView<
    UnitType: RawRepresentable & CaseIterable & Hashable
>: View where UnitType.RawValue == String {
    @Binding var value: String
    @Binding var selectedUnit: UnitType
    let title: String
    let maxIntegerDigits: Int
    let normalizeAction: () -> Void
    
    @FocusState private var focus: Bool
    
    var body: some View {
        Form {
            ServingTextFieldView(
                text: $value,
                maxIntegerDigits: maxIntegerDigits
            )
            .focused($focus)
            
            Picker(
                "Unit",
                selection: $selectedUnit
            ) {
                ForEach(Array(UnitType.allCases), id: \.self) { unit in
                    Text(String(describing: unit))
                        .tag(unit)
                }
            }
        }
        .navigationTitle(title)
        .safeAreaInset(edge: .bottom) {
            if focus {
                KeyboardToolbarView(
                    done: {
                        focus = false
                        normalizeAction()
                    }
                )
            }
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
