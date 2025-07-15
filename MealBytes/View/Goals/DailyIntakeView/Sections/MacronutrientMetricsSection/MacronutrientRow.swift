//
//  MacronutrientRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientRow: View {
    @Binding var textFieldBinding: String
    var focusedField: FocusState<MacronutrientsFocus?>.Binding
    let title: String
    let titleColor: Color
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $textFieldBinding,
                title: title,
                keyboardType: .numberPad,
                inputMode: .integer,
                titleColor: titleColor,
                maxIntegerDigits: 3
            )
            .focused(focusedField, equals: focusValue)
            .padding(.trailing, 5)
            
            Text("g")
        }
    }
    
    private var focusValue: MacronutrientsFocus {
        switch title {
        case "Fat": return .fat
        case "Carbohydrate": return .carbohydrate
        case "Protein": return .protein
        default: return .fat
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    return NavigationStack {
        DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
    }
}
