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
        } footer: {
            if let email = profileViewModel.email {
                VStack {
                    Text("This account is signed in:")
                        .font(.subheadline)
                    Text(email)
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                }
            } else {
                Text("Account disconnected.")
                    .font(.subheadline)
            }
        }
        .listRowBackground(Color.clear)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom)
    }
}
