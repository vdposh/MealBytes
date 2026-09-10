//
//  EmailAndPasswordSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10.09.2026.
//

import SwiftUI

struct EmailAndPasswordSection: View {
    @Binding var email: String?
    
    var body: some View {
        Section {
            NavigationLink {
                EmailView(currentEmail: email ?? "")
            } label: {
                LabeledContent {
                    Text(email ?? "")
                } label: {
                    Text("Email")
                }
            }
            
            NavigationLink {
                PasswordView()
            } label: {
                LabeledContent {
                    Text("••••••••")
                } label: {
                    Text("Password")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
