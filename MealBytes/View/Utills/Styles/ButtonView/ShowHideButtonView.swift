//
//  ShowHideButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/03/2025.
//

import SwiftUI

struct ShowHideButtonView: View {
    @Binding var isExpanded: Bool
    
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
            .lineLimit(1)
            .labelIconToTitleSpacing(2)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PreviewContentView.contentView
}
