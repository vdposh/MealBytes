//
//  SignOutSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//


import SwiftUI

struct SignOutAndDeleteSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Button(role: .close) {
                profileViewModel.prepareAlert(for: .signOut)
            } label: {
                Text("Sign Out")
            }
            
            if profileViewModel.isDeletingAccount {
                LoadingView()
            } else {
                Button(role: .destructive) {
                    profileViewModel.prepareAlert(for: .deleteAccount)
                } label: {
                    Text("Delete Account")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
