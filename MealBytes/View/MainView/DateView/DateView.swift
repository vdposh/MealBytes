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
            Text("\(Calendar.current.component(.day, from: date))")
                .foregroundColor(isToday || isSelected ? .customGreen : .primary)
            Text(date.formatted(.dateTime.weekday(.short)))
                .foregroundColor(isToday || isSelected ? .customGreen : .gray)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(isSelected ? Color.customGreen.opacity(0.2) : Color.clear)
        .cornerRadius(12)
    }
}

