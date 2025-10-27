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
                placeholder: "Years old",
                keyboardType: .numberPad,
                inputMode: .integer,
                maxIntegerDigits: 3
            )
            .focused($focusedField, equals: .age)
        } header: {
            Text("Age")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(
                    rdiViewModel.fieldTitleColor(for: rdiViewModel.age)
                )
        } footer: {
            Text("Enter full age to personalize recommendations.")
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
