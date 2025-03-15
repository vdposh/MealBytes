//
//  ShowHideButtonView.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct ShowHideButtonView: View {
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            HStack {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.customGreen)
                Text(isExpanded ? "Hide" : "Show")
                    .font(.subheadline)
                    .foregroundColor(.customGreen)
            }
            .frame(maxWidth: .infinity)
        }
        .listRowSeparator(.hidden)
    }
}
