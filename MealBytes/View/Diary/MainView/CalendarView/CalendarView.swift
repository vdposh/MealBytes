//
//  CalendarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/03/2025.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text(mainViewModel.formattedDate())
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .padding(.bottom, 26)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7)
            ) {
                ForEach(
                    mainViewModel.weekdaySymbols(),
                    id: \.self
                ) { symbol in
                    Text(symbol)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 2)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 7)
            ) {
                ForEach(
                    mainViewModel.daysForCurrentMonth(
                        selectedDate: mainViewModel.date
                    ),
                    id: \.self
                ) { date in
                    Button {
                        mainViewModel.selectDate(
                            date,
                            selectedDate: &mainViewModel.date,
                            isPresented: &mainViewModel.isExpandedCalendar
                        )
                    } label: {
                        VStack(spacing: 3) {
                            Text("\(mainViewModel.dayComponent(for: date))")
                                .foregroundStyle(mainViewModel.color(
                                    for: .day,
                                    date: date,
                                    isSelected: mainViewModel.calendar.isDate(
                                        mainViewModel.date,
                                        inSameDayAs: date
                                    ),
                                    isToday: mainViewModel
                                        .calendar.isDateInToday(date)
                                ))
                                .font(.callout)
                            
                            if mainViewModel.hasMealItems(for: date) {
                                Circle()
                                    .frame(width: 5, height: 5)
                            }
                        }
                        .frame(width: 40, height: 40)
                        .background(
                            mainViewModel.color(
                                for: .day,
                                date: date,
                                isSelected: mainViewModel.calendar.isDate(
                                    mainViewModel.date,
                                    inSameDayAs: date
                                ),
                                forBackground: true
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.bottom)
        .padding(.top, 24)
    }
}

#Preview {
    PreviewContentView.contentView
}
