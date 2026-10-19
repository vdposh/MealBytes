//
//  UnitsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16.10.2026.
//

import SwiftUI

struct UnitsSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            EnergyUnitView(profileViewModel: profileViewModel)
        } header: {
            Text("Unit")
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
