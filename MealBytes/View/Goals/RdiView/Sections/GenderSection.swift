//
//  GenderSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/06/2025.
//

import SwiftUI

struct GenderSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            Picker(
                "Gender",
                selection: $rdiViewModel.selectedGender
            ) {
                if rdiViewModel.selectedGender == .notSelected {
                    Text("Not Selected").tag(Gender.notSelected)
                }
                
                ForEach(
                    Gender.allCases.filter { $0 != .notSelected },
                    id: \.self
                ) { gender in
                    Text(gender.rawValue).tag(gender)
                }
            }
            .foregroundStyle(rdiViewModel.selectedGender.selectedColor)
        } footer: {
            Text("Specify gender to ensure RDI calculations.")
        }
    }
}

enum Gender: String, CaseIterable {
    case notSelected = "Not selected"
    case male = "Male"
    case female = "Female"
    
    var selectedColor: Color {
        switch self {
        case .notSelected: .customRed
        case .male, .female: .primary
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
