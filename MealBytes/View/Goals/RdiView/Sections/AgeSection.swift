//
//  AgeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct AgeSection: View {
    @FocusState var focusedField: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            ServingTextFieldView(
                text: $rdiViewModel.age,
                title: "Age",
                keyboardType: .numberPad,
                inputMode: .integer,
                titleColor: rdiViewModel.fieldTitleColor(
                    for: rdiViewModel.age
                ),
                maxIntegerDigits: 3
            )
            .focused($focusedField, equals: .age)
        } footer: {
            Text("Enter age to personalize recommendations.")
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PreviewRdiView.rdiView
}
