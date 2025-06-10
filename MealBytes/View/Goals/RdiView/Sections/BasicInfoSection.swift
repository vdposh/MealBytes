//
//  BasicInfoSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct BasicInfoSection: View {
    @FocusState var focusedField: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            VStack(alignment: .leading, spacing: 11) {
                ServingTextFieldView(
                    text: $rdiViewModel.age,
                    title: "Age",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.age),
                    maxFractionalDigits: 1,
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .age)
                
                Picker("Gender", selection: $rdiViewModel.selectedGender) {
                    if rdiViewModel.selectedGender == .notSelected {
                        Text("Not Selected").tag(Gender.notSelected)
                    }
                    ForEach(Gender.allCases.filter { $0 != .notSelected },
                            id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(rdiViewModel.selectedGender.accentColor)
            }
        } header: {
            Text("Basic Information")
        } footer: {
            Text("Specify age and gender to personalize recommendations.")
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
