//
//  BodyProfileSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 27/03/2025.
//

import SwiftUI

struct BodyProfileSection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        NavigationLink {
            BodyProfileView(rdiViewModel: rdiViewModel)
        } label: {
            LabeledContent {
                Text(rdiViewModel.bodyProfileText)
            } label: {
                Text("Age & Sex")
            }
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
