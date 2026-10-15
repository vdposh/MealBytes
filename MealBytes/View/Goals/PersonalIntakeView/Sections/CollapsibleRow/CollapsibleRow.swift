//
//  CollapsibleRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 28.09.2026.
//

import SwiftUI

struct CollapsibleRow<Content: View>: View {
    let title: String
    let value: String
    let isExpanded: Bool
    let onToggle: () -> Void
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Button {
            withAnimation {
                onToggle()
            }
        } label: {
            Text(title)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(alignment: .trailing) {
            Text(value)
                .foregroundStyle(isExpanded ? .accent : .primary)
                .padding(10)
                .background(Color(.systemGroupedBackground), in: .capsule)
        }
        
        if isExpanded {
            content()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
