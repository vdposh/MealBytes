//
//  DateView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct DateView: View {
    let mainViewModel: MainViewModel
    let date: Date
    let isToday: Bool
    let isSelected: Bool

    var body: some View {
        VStack {
            Text(date.formatted(.dateTime.day()))
                .foregroundColor(
                    mainViewModel.color(for: .day,
                                        date: date,
                                        isSelected: isSelected,
                                        isToday: isToday)
                )
            Text(date.formatted(.dateTime.weekday(.short)))
                .foregroundColor(
                    mainViewModel.color(for: .weekday,
                                        date: date,
                                        isSelected: isSelected,
                                        isToday: isToday)
                )
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(
            mainViewModel.color(for: .day,
                                date: date,
                                isSelected: isSelected,
                                forBackground: true)
        )
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
