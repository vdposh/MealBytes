//
//  NutrientFieldRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25.09.2026.
//

import SwiftUI

struct NutrientFieldRow<Focus: Hashable>: View {
    let type: NutrientType
    @Binding var text: String
    let focus: FocusState<Focus?>.Binding
    let focusCase: Focus
    var maxIntegerDigits: Int = 3
    
    var body: some View {
        HStack(spacing: 4) {
            ServingTextFieldView(
                text: $text,
                labelIconName: type.iconName,
                labelIconColor: type.iconColor,
                stackText: type.title,
                useStackTrailing: true,
                keyboardType: .numberPad,
                inputMode: .integer,
                maxIntegerDigits: maxIntegerDigits
            )
            .focused(focus, equals: focusCase)
            
            Text(type.unitType.unitDescription(for: Double(text) ?? 0))
                .foregroundStyle(
                    text.isEmpty ? Color(.placeholderText) : .primary
                )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
