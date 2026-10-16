//
//  AccountSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15.10.2026.
//

import SwiftUI

struct AccountSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            NavigationLink {
                AccountView(profileViewModel: profileViewModel)
            } label: {
                LabeledContent {
                    Text(profileViewModel.email ?? "")
                } label: {
                    Text("Account")
                }
            }
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
