//
//  AccountSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct AccountSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationLink {
            AccountView(profileViewModel: profileViewModel)
        } label: {
            LabeledContent {
                if let email = profileViewModel.email {
                    Text(email)
                } else {
                    Text("Account disconnected")
                }
            } label: {
                Text("Account")
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
