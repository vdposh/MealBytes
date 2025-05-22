//
//  BasicInfoSection.swift
//  MealBytes
//
//  Created by Porshe on 27/03/2025.
//

import SwiftUI

struct BasicInfoSection: View {
    @FocusState var focusedField: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section(header: Text("Basic Information")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.age,
                    title: "Age",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.age),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .age)
                
                VStack {
                    HStack {
                        Picker("Gender",
                               selection: $rdiViewModel.selectedGender) {
                            ForEach(Gender.allCases,
                                    id: \.self) { gender in
                                Text(gender.rawValue)
                            }
                        }
                               .pickerStyle(.menu)
                               .accentColor(
                                rdiViewModel.selectedGender.accentColor
                               )
                    }
                    
                    Divider()
                    
                    HStack {
                        Picker("Activity Level",
                               selection: $rdiViewModel.selectedActivity) {
                            ForEach(ActivityLevel.allCases,
                                    id: \.self) { level in
                                Text(level.rawValue)
                            }
                        }
                               .padding(.top, 5)
                               .pickerStyle(.menu)
                               .accentColor(
                                rdiViewModel.selectedActivity.accentColor
                               )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RdiView()
    }
}
