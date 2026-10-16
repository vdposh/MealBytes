//
//  ProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        profileViewContentBody
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
    }
    
    private var profileViewContentBody: some View {
        Form {
            AccountSection(profileViewModel: profileViewModel)
            GoalsSettingsSection(profileViewModel: profileViewModel)
            UnitsSection(profileViewModel: profileViewModel)
            AppearanceSection()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
