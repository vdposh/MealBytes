//
//  DateView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct DateView: View {
    let date: Date
    let isToday: Bool
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.day()))
                .foregroundColor(color(for: .day))
            Text(date.formatted(.dateTime.weekday(.short)))
                .foregroundColor(color(for: .weekday))
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(
            {
                switch isSelected {
                case true:
                    Color.customGreen.opacity(0.2)
                case false:
                    Color.clear
                }
            }()
        )
        .cornerRadius(12)
    }
    
    private func color(for element: DisplayElement) -> Color {
        if isSelected || isToday {
            return .customGreen
        }

        switch element {
        case .day:
            return .primary
        case .weekday:
            return .secondary
        }
    }
}
