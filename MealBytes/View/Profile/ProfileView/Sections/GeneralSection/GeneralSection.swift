//
//  GeneralSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.10.2026.
//

import SwiftUI

struct GeneralSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            NavigationLink {
                Form {
                    GoalsToggleSection(profileViewModel: profileViewModel)
                    EnergyUnitSection(profileViewModel: profileViewModel)
                }
                .navigationTitle("General")
                .navigationBarTitleDisplayMode(.inline)
            } label: {
                Text("General")
            }
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
