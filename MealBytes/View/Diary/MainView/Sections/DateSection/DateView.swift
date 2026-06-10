//
//  DateView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct DateView: View {
    let date: Date
    let isToday: Bool
    let isSelected: Bool
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 3) {
            Text(date.formatted(.dateTime.weekday()))
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(
                    mainViewModel.color(
                        for: date,
                        isSelected: isSelected,
                        isToday: isToday,
                        isWeekday: true
                    )
                )
            
            Text(date.formatted(.dateTime.day()))
                .fontWeight(.medium)
                .foregroundStyle(
                    mainViewModel.color(
                        for: date,
                        isSelected: isSelected,
                        isToday: isToday
                    )
                )
        }
        .frame(maxWidth: .infinity)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.accent)
                    .frame(height: 65)
            }
        }
        .transaction { $0.animation = nil }
    }
}

#Preview {
    PreviewContentView.contentView
}
