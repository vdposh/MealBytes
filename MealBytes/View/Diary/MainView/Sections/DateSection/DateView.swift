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
        VStack {
            Text(date.formatted(.dateTime.day()))
                .foregroundStyle(
                    mainViewModel.color(
                        for: .day,
                        date: date,
                        isSelected: isSelected,
                        isToday: isToday,
                        forcePrimary: true
                    )
                )
            
            Text(date.formatted(.dateTime.weekday(.short)))
                .foregroundStyle(
                    mainViewModel.color(
                        for: .weekday,
                        date: date,
                        isSelected: isSelected,
                        isToday: isToday
                    )
                )
                .font(.footnote)
        }
        .padding(5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            mainViewModel.color(
                for: .day,
                date: date,
                isSelected: isSelected,
                forBackground: true
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    PreviewContentView.contentView
}
