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
            SignOutButtonView(title: "Sign Out") {
                profileViewModel.prepareAlert(for: .signOut)
            }
        } footer: {
            if profileViewModel.isDeletingAccount {
                HStack {
                    ProgressView()
                    Text("Deleting account...")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            } else {
                HStack(spacing: 4) {
                    Text("Do you want to")
                    
                    Button("delete") {
                        profileViewModel.prepareAlert(for: .deleteAccount)
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .accentColor(.customRed)
                    .buttonStyle(.borderless)
                    
                    Text("the account?")
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
