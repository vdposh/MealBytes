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
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                profileViewToolbar
            }
    }
    
    private var profileViewContentBody: some View {
        Form {
            GeneralSection(profileViewModel: profileViewModel)
            AppearanceSection()
        }
        .sheet(isPresented: $profileViewModel.showAccountView) {
            NavigationStack {
                AccountView(profileViewModel: profileViewModel)
            }
        }
    }
    
    @ToolbarContentBuilder
    private var profileViewToolbar: some ToolbarContent {
        ToolbarItem {
            Button {
                profileViewModel.showAccountView = true
            } label: {
                Text("Account")
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
