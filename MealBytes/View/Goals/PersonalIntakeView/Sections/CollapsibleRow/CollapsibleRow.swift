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
            LabeledContent {
                HStack(spacing: 10) {
                    Text(value)
                        .foregroundStyle(isExpanded ? .primary : .secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(isExpanded ? .primary : .tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .animation(.default, value: isExpanded)
                }
                .padding(.trailing, 2)
            } label: {
                Text(title)
                    .foregroundStyle(Color.primary)
            }
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
