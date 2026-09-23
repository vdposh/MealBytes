//
//  BodyProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct BodyProfileView: View {
    @FocusState private var focus: Bool
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Form {
            Section {
                ServingTextFieldView(
                    text: $personalIntakeViewModel.age,
                    stackText: "Age",
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus)
            }
            
            Section {
                GenderView(
                    selectedGender: $personalIntakeViewModel.selectedGender
                )
            }
        }
        .navigationTitle("Body Profile")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            ToolbarButtonView(
                action: {
                    focus = false
                    personalIntakeViewModel.normalizeAge()
                },
                alignment: .trailing,
                focused: focus
            )
            .opacity(focus ? 1 : 0)
            .allowsHitTesting(focus)
        }
        .ignoresSafeArea(edges: focus ? [] : .bottom)
    }
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
