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
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private var profileViewContentBody: some View {
        Form {
            AccountSection(profileViewModel: profileViewModel)
            
            Section {
                ThemePickerSection()
                
                if !profileViewModel.mainViewModel.intake.isEmpty {
                    IntakeToggleSection(profileViewModel: profileViewModel)
                }
            } footer: {
                if !profileViewModel.mainViewModel.intake.isEmpty {
                    Text("Enable to display daily intake progress directly in the Diary.")
                }
            }
        }
        .id(profileViewModel.uniqueId)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
