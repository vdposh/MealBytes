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
    var showCount: Bool = false
    var itemCount: Int = 0
    
    var body: some View {
        Button {
            withAnimation {
                isExpanded.toggle()
            }
        } label: {
            if showCount && !isExpanded {
                Label {
                    Text(itemCount == 1 ? "1 entry" : "\(itemCount) entries")
                        .font(.footnote)
                } icon: {
                    Image(
                        systemName: isExpanded ? "chevron.up" : "chevron.down"
                    )
                    .imageScale(.small)
                }
            } else {
                Label {
                    Text(isExpanded ? "Hide" : "More")
                        .font(.footnote)
                } icon: {
                    Image(
                        systemName: isExpanded ? "chevron.up" : "chevron.down"
                    )
                    .imageScale(.small)
                }
            }
            
            if context {
                Text(isExpanded ? "Collapse section" : "Expand section")
            }
        }
        .transaction { $0.animation = nil }
        .lineLimit(1)
        .labelIconToTitleSpacing(2)
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PreviewContentView.contentView
}
