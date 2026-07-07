//
//  SignOutSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//


import SwiftUI

struct SignOutSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Button("Sign Out") {
                profileViewModel.prepareAlert(for: .signOut)
            }
            .foregroundStyle(.customRed)
        }
        
        Section {
            if profileViewModel.isDeletingAccount {
                LoadingView(showLabel: true)
            } else {
                Button("Delete Account") {
                    profileViewModel.prepareAlert(for: .deleteAccount)
                }
                .foregroundStyle(.customRed)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
