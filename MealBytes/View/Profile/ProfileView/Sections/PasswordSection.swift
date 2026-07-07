//
//  PasswordSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//


import SwiftUI

struct PasswordSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            if profileViewModel.isPasswordChanging {
                LoadingView(showLabel: true)
            } else {
                Button("Change Password") {
                    profileViewModel.prepareAlert(for: .changePassword)
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
