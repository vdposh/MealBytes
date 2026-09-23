//
//  GenderView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 17.09.2026.
//

import SwiftUI

struct GenderView: View {
    @Binding var selectedGender: Gender
    
    var body: some View {
        ForEach(
            Gender.allCases.filter { $0 != .notSelected },
            id: \.self
        ) { gender in
            SelectionRow(
                title: gender.rawValue,
                isSelected: selectedGender == gender
            ) {
                selectedGender = gender
            }
        }
    }
}

enum Gender: String, CaseIterable {
    case notSelected = ""
    case male = "Male"
    case female = "Female"
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewRdiView.rdiView
}
