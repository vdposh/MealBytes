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
                Button {
                    profileViewModel.prepareAlert(for: .changePassword)
                } label: {
                    Text("Change Password")
                }
            }
        } footer: {
            Text("Use this option to update the account password for improved security.")
                .padding(.bottom)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
