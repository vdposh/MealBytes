//
//  BodyProfileSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct BodyProfileSection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        NavigationLink {
            BodyProfileView(personalIntakeViewModel: personalIntakeViewModel)
        } label: {
            LabeledContent {
                Text(personalIntakeViewModel.bodyProfileText)
            } label: {
                Text("Age & Sex")
            }
        }
    }
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
