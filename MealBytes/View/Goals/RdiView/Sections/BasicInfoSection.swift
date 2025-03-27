//
//  BasicInfoSection.swift
//  MealBytes
//
//  Created by Porshe on 27/03/2025.
//

import SwiftUI

struct BasicInfoSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    @FocusState private var isAgeFocused: Bool
    
    var body: some View {
        Section(header: Text("Basic Information")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.age,
                    title: "Age",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.age)
                )
                .focused($isAgeFocused)
                
                HStack {
                    Picker("Gender", selection: $rdiViewModel.selectedGender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue)
                        }
                    }
                    .font(.callout)
                }
                .frame(height: 30)
                
                HStack {
                    Picker("Activity Level",
                           selection: $rdiViewModel.selectedActivity) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.rawValue)
                        }
                    }
                    .font(.callout)
                }
                .frame(height: 30)
            }
        }
    }
}
