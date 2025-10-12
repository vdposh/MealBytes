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
        .background {
            if isSelected {
                Color.clear
                    .glassEffect(
                        .clear.interactive().tint(
                            mainViewModel.color(
                                for: .day,
                                date: date,
                                isSelected: isSelected,
                                forBackground: true
                            )
                        ),
                        in: .rect(cornerRadius: 16)
                    )
            } else {
                Color.clear
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
