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
        VStack {
            Text(date.formatted(.dateTime.weekday()))
                .font(.caption2)
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
        .padding(.vertical, 12)
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
