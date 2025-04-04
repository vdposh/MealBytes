//
//  ServingButtonView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct ServingButtonView: View {
    @Binding var showActionSheet: Bool
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Button(action: action) {
                HStack {
                    Text(description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 10, height: 6)
                }
                .padding(.vertical, 5)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary),
                    alignment: .bottom
                )
            }
            .buttonStyle(.plain)
        }
    }
}
