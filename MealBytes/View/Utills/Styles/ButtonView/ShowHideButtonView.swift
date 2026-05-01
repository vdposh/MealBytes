//
//  ShowHideButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/03/2025.
//

import SwiftUI

struct ShowHideButtonView: View {
    @Binding var isExpanded: Bool
    var context: Bool = false
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            Label {
                Text(isExpanded ? "Hide" : "Show")
                    .font(.footnote)
            } icon: {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .imageScale(.small)
            }
            .transaction { $0.animation = nil }
            .lineLimit(1)
            .labelIconToTitleSpacing(2)
            .frame(maxWidth: .infinity, alignment: .center)
            
            
            if context {
                Text(isExpanded ? "Collapse section" : "Expand section")
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PreviewContentView.contentView
}
