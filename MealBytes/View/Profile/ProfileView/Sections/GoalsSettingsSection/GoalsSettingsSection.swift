//
//  GoalsSettingsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.10.2026.
//

import SwiftUI

struct GoalsSettingsSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            GoalsCardsView(profileViewModel: profileViewModel)
        } header: {
            Text("Goals")
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
