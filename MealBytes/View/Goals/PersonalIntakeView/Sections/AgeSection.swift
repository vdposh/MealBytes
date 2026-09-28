//
//  AgeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24.03.2025.
//

import SwiftUI

struct AgeSection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        CollapsibleRow(
            title: "Age",
            value: personalIntakeViewModel.age.isEmpty
            ? ""
            : personalIntakeViewModel.formattedAge,
            isExpanded: personalIntakeViewModel.isExpandedAge,
            onToggle: {
                personalIntakeViewModel.toggleSection(.age)
            }
        ) {
            Picker("Age", selection: $personalIntakeViewModel.age) {
                ForEach(1...120, id: \.self) { age in
                    Text("\(age)")
                        .tag("\(age)")
                }
            }
            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
