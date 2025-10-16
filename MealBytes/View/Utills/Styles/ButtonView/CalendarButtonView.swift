//
//  CalendarButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/07/2025.
//

import SwiftUI

struct CalendarButtonView: View {
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if colorScheme == .light {
                Color.primary
                    .opacity(0.4)
                    .ignoresSafeArea()
            } else {
                Color(.secondarySystemBackground)
                    .opacity(0.6)
                    .ignoresSafeArea()
            }
        }
        .buttonStyle(ButtonStyleInvisible())
    }
}

#Preview {
    PreviewContentView.contentView
}
