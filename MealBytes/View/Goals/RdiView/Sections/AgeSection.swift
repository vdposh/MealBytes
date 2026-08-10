//
//  AgeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct AgeSection: View {
    let focus: FocusState<Bool>.Binding
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        ServingTextFieldView(
            text: $rdiViewModel.age,
            stackText: "Age",
            useStackTrailing: true,
            keyboardType: .numberPad,
            inputMode: .integer,
            maxIntegerDigits: 3
        )
        .focused(focus)
    }
}

#Preview {
    PreviewRdiView.rdiView
}
