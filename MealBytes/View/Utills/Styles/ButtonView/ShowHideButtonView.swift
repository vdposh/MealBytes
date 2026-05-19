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
                    Text(entryText)
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
                Text(isExpanded ? "Collapse meal type" : entryText)
            }
        }
        .transaction { $0.animation = nil }
        .lineLimit(1)
        .labelIconToTitleSpacing(2)
        .frame(maxWidth: .infinity, alignment: .center)
        .listRowSeparator(.hidden)
    }
    
    private var entryText: String {
        itemCount == 1 ? "1 entry" : "\(itemCount) entries"
    }
}

#Preview {
    PreviewContentView.contentView
}
