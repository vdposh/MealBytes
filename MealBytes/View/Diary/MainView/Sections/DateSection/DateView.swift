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
    let mainViewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 5) {
            Text(date.formatted(.dateTime.weekday()))
                .font(.footnote)
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
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 18)
                    .fill(.accent)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
