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
            .frame(maxWidth: .infinity, alignment: .center)
        } footer: {
            if profileViewModel.isDeletingAccount {
                HStack {
                    ProgressView()
                    Text("Deleting account...")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.bottom)
            } else {
                HStack(spacing: 4) {
                    Text("Do you want to")
                    
                    Button("delete") {
                        profileViewModel.prepareAlert(for: .deleteAccount)
                    }
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.customRed)
                    
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
