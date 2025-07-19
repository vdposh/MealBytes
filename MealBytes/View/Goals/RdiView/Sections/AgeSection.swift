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
        VStack(alignment: .leading) {
            Text("AGE DETAILS")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
            ServingTextFieldView(
                text: $rdiViewModel.age,
                title: "Age",
                keyboardType: .numberPad,
                inputMode: .integer,
                titleColor: rdiViewModel.fieldTitleColor(for: rdiViewModel.age),
                maxIntegerDigits: 3
            )
            .focused($focusedField, equals: .age)
            .id("ageField")
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(14)
            .padding(.horizontal, 20)
            
            Text("Enter age to personalize recommendations.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 25)
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
