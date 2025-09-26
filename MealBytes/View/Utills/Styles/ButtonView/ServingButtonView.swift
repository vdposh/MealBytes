//
//  ServingButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingButtonView: View {
    @Binding var showActionSheet: Bool
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .frame(height: 10)
            
            HStack {
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 10, height: 6)
            }
        }
        .overlay(
            Button(action: {
                action()
            }) {
                Color.clear
            }
        )
        .buttonStyle(.borderless)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
