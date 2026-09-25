//
//  SexSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct SexSection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Picker("Sex", selection: $personalIntakeViewModel.selectedSex) {
            ForEach(
                Sex.allCases.filter { $0 != .notSelected },
                id: \.self
            ) { sex in
                Text(sex.rawValue)
                    .tag(sex)
            }
        }
    }
}

enum Sex: String, CaseIterable {
    case notSelected = ""
    case notSet = "Not Set"
    case male = "Male"
    case female = "Female"
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
