//
//  BodyProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct BodyProfileView: View {
    @FocusState private var focus: Bool
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Form {
            Section {
                ServingTextFieldView(
                    text: $rdiViewModel.age,
                    stackText: "Age",
                    useStackTrailing: true,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 3
                )
                .focused($focus)
            }
            
            Section {
                GenderView(selectedGender: $rdiViewModel.selectedGender)
            }
        }
        .navigationTitle("Body Profile")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            ToolbarButtonView(
                action: {
                    focus = false
                    rdiViewModel.normalizeAge()
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
    PreviewRdiView.rdiView
}
