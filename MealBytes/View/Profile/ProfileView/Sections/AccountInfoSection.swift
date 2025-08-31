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
                        .font(.headline)
                }
            } else {
                Text("Account disconnected.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.bottom)
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowBackground(Color.clear)
    }
}
