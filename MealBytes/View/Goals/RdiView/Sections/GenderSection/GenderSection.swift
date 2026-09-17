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
        NavigationLink {
            GenderView(selectedGender: $rdiViewModel.selectedGender)
        } label: {
            LabeledContent {
                Text(rdiViewModel.selectedGender.rawValue)
            } label: {
                Text("Gender")
            }
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
