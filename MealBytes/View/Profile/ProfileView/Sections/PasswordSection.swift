//
//  PasswordSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 09.09.2026.
//

import SwiftUI

struct PasswordSection: View {
    var body: some View {
        Section {
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
