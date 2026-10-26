//
//  GoalsNutrientFieldRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25.09.2026.
//

import SwiftUI

struct GoalsNutrientFieldRow<Focus: Hashable>: View {
    let type: NutrientType
    @Binding var text: String
    let focus: FocusState<Focus?>.Binding
    let focusCase: Focus
    var maxIntegerDigits: Int = 3
    var unit: UnitNutrients? = nil
    
    var displayUnit: UnitNutrients {
        unit ?? type.unitType
    }
    
    var body: some View {
        ServingTextFieldView(
            text: $text,
            focus: focus,
            focusCase: focusCase,
            unitText: displayUnit.unitDescription(for: text.doubleValue ?? 0),
            labelIconName: type.iconName,
            labelIconColor: type.iconColor,
            stackText: type.title,
            useLabel: true,
            keyboardType: .numberPad,
            inputMode: .integer,
            maxIntegerDigits: maxIntegerDigits
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
