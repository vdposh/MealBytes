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
            if let email = profileViewModel.email {
                HStack(spacing: 10) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.tertiary)
                    
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        
                        Text(email)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            } else {
                Text("Account disconnected")
                    .font(.title3)
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
