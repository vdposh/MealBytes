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
        VStack(alignment: .leading) {
            Text("HEIGHT DETAILS")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
            VStack {
                ServingTextFieldView(
                    text: $rdiViewModel.height,
                    title: "Height",
                    titleColor: rdiViewModel.fieldTitleColor(
                        for: rdiViewModel.height
                    ),
                    maxIntegerDigits: 3
                )
                .focused($focusedField, equals: .height)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                HStack {
                    Text("Height Unit")
                        .padding(.leading, 20)
                    
                    Picker("Height Unit",
                           selection: $rdiViewModel.selectedHeightUnit) {
                        if rdiViewModel.selectedHeightUnit == .notSelected {
                            Text("Not Selected").tag(HeightUnit.notSelected)
                        }
                        ForEach(
                            HeightUnit.allCases.filter { $0 != .notSelected },
                            id: \.self
                        ) { height in
                            Text(height.rawValue).tag(height)
                        }
                    }
                           .pickerStyle(.menu)
                           .accentColor(
                            rdiViewModel.selectedHeightUnit.accentColor
                           )
                           .frame(maxWidth: .infinity, alignment: .trailing)
                           .padding(.trailing, 10)
                }
                .padding(.top, 2)
                .padding(.bottom, 10)
            }
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .id("heightField")
            
            Text("Enter height and, if necessary, adjust the unit (centimeters or inches).")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
                .padding(.bottom, 25)
        }
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
