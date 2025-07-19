//
//  HeightSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct HeightSection: View {
    @FocusState var focusedField: RdiFocus?
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        SectionStyleContainer(
            mainContent: {
                ServingTextFieldView(
                    text: $rdiViewModel.height,
                    title: "Height",
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.height
                    ),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .height)
            },
            secondaryContent: {
                AnyView(
                    HStack {
                        Text("Height Unit")
                        
                        Picker("Height Unit",
                               selection: $rdiViewModel.selectedHeightUnit) {
                            if rdiViewModel.selectedHeightUnit == .notSelected {
                                Text("Not Selected").tag(HeightUnit.notSelected)
                            }
                            ForEach(
                                HeightUnit.allCases.filter {
                                    $0 != .notSelected },
                                id: \.self
                            ) { unit in
                                Text(unit.rawValue).tag(unit)
                            }
                        }
                               .pickerStyle(.menu)
                               .accentColor(
                                rdiViewModel.selectedHeightUnit.accentColor
                               )
                               .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                )
            },
            layout: .pickerUnit,
            title: "Height Details",
            description: "Enter height and, if necessary, adjust the unit (centimeters or inches)."
        )
        .id("heightField")
    }
}

enum HeightUnit: String, CaseIterable {
    case notSelected = "Not selected"
    case cm = "cm"
    case inches = "inches"
    
    var accentColor: Color {
        switch self {
        case .notSelected:
            return .customRed
        default:
            return .customGreen
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
