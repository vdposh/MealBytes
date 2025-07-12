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
                    for: rdiViewModel.age),
                maxIntegerDigits: 3
            )
            .focused($focusedField, equals: .age)
            .padding(.bottom, 5)
            .id("ageField")
        } header: {
            Text("Age Details")
        } footer: {
            Text("Enter age to personalize recommendations.")
        }
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)

    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
