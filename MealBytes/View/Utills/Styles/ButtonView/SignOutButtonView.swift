//
//  SignOutButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 31/03/2025.
//

import SwiftUI

struct SignOutButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .foregroundStyle(.customRed)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    PreviewContentView.contentView
}
