//
//  AccountInfoSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct AccountInfoSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            if let email = profileViewModel.email {
                VStack {
                    Text("This account is signed in:")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    
                    Text(email)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            } else {
                Text("Account disconnected.")
                    .font(.subheadline)
            }
        }
        .listSectionMargins(.vertical, 10)
        .listRowBackground(Color.clear)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
