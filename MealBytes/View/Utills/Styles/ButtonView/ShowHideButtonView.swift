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
            HStack {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                Text(isExpanded ? "Hide" : "Show")
            }
            .lineLimit(1)
            .font(.footnote)
            .accentForeground()
            .frame(maxWidth: .infinity)
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PreviewContentView.contentView
}
