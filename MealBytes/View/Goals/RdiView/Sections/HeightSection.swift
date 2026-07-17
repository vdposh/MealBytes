//
//  HeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct HeightSection: View {
    @FocusState var focus: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            ServingTextFieldView(
                text: $rdiViewModel.height,
                maxIntegerDigits: 3
            )
            .focused($focus, equals: .height)
            
            Picker(
                "Unit",
                selection: $rdiViewModel.selectedHeightUnit
            ) {
                ForEach(
                    HeightUnit.allCases,
                    id: \.self
                ) { unit in
                    Text(unit.rawValue).tag(unit)
                }
            }
        } header: {
            Text("Height")
                .foregroundStyle(
                    rdiViewModel.fieldTitleColor(for: rdiViewModel.height)
                )
        }
    }
}

enum HeightUnit: String, CaseIterable {
    case cm = "cm"
    case inches = "inches"
    
    var selectedColor: Color {
        .primary
    }
}

#Preview {
    PreviewRdiView.rdiView
}
