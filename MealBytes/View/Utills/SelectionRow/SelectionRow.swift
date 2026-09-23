//
//  SelectionRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23.09.2026.
//

import SwiftUI

struct SelectionRow: View {
    let title: String
    var description: String? = nil
    let isSelected: Bool
    var checkmarkColor: Color = .accent
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(Color.primary)
                
                if let description {
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 50)
            .overlay(alignment: .trailing) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.headline)
                        .foregroundStyle(checkmarkColor)
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
