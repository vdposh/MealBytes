//
//  HeightSection.swift
//  MealBytes
//
//  Created by Porshe on 27/03/2025.
//

import SwiftUI

struct HeightSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    @FocusState private var isHeightFocused: Bool
    
    var body: some View {
        Section(header: Text("Height")) {
            VStack(alignment: .leading, spacing: 15) {
                ServingTextFieldView(
                    text: $rdiViewModel.height,
                    title: "Height",
                    keyboardType: .decimalPad,
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.height)
                )
                .focused($isHeightFocused)
                
                Picker("Unit", selection: $rdiViewModel.selectedHeightUnit) {
                    ForEach(HeightUnit.allCases, id: \.self) { unit in
                        Text(unit.rawValue)
                    }
                }
                .font(.callout)
            }
        }
    }
}
