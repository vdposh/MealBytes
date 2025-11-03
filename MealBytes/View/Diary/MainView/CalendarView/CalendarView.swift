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
        VStack(spacing: 30) {
            Text(mainViewModel.formattedDate())
                .font(.headline)
            
            VStack(spacing: 10) {
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
                            withAnimation {
                                mainViewModel.isCalendarInteractive = false
                            }
                            
                            withTransaction(
                                Transaction(animation: .bouncy)
                            ) {
                                mainViewModel.selectDate(
                                    date,
                                    selectedDate: &mainViewModel.date,
                                    isPresented: &mainViewModel
                                        .isExpandedCalendar
                                )
                            }
                            
                            withAnimation {
                                mainViewModel.isCalendarInteractive = true
                            }
                        } label: {
                            VStack(spacing: 5) {
                                Text(
                                    "\(mainViewModel.dayComponent(for: date))"
                                )
                                .foregroundStyle(
                                    mainViewModel
                                        .color(
                                            for: .day,
                                            date: date,
                                            isSelected: mainViewModel.calendar
                                                .isDate(
                                                    mainViewModel.date,
                                                    inSameDayAs: date
                                                ),
                                            isToday: mainViewModel.calendar
                                                .isDateInToday(date)
                                        )
                                )
                                .font(.callout)
                                
                                if mainViewModel.hasMealItems(for: date) {
                                    Circle()
                                        .frame(width: 5, height: 5)
                                        .padding(.bottom, 2)
                                        .foregroundStyle(.accent)
                                }
                            }
                            .frame(width: 45, height: 45)
                        }
                        .background {
                            mainViewModel.colorBackground(for: date)
                        }
                        .glassEffect(
                            .identity.interactive(),
                            in: .rect(cornerRadius: 16)
                        )
                        .buttonStyle(ButtonStyleInvisible())
                    }
                }
            }
        }
        .transaction { $0.animation = nil }
        .lineLimit(1)
        .padding(.horizontal, 12)
        .padding(.bottom)
        .padding(.top, 24)
        .background(Color(.systemBackground))
        .clipShape(.rect(cornerRadius: 24))
        .transition(.blurReplace)
    }
}

#Preview {
    PreviewContentView.contentView
}
