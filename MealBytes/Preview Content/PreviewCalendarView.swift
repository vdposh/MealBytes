//
//  PreviewCalendarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 03.04.2026.
//

import SwiftUI

struct PreviewCalendarView {
    static var calendarView: some View {
        let mainViewModel = MainViewModel()
        let calendar = Calendar.current
        let startDate = Date()
        
        for dayOffset in 0...10 {
            if let date = calendar.date(
                byAdding: .day,
                value: dayOffset,
                to: startDate
            ) {
                let testMealItem = MealItem(
                    foodId: dayOffset,
                    foodName: "Test Food \(dayOffset)",
                    portionUnit: "serving",
                    nutrients: [:],
                    measurementDescription: "test",
                    amount: 1,
                    date: date,
                    mealType: .breakfast
                )
                mainViewModel
                    .addMealItemMainView(
                        testMealItem,
                        to: .breakfast,
                        for: date
                    )
            }
        }
        
        return NavigationStack {
            CalendarView(mainViewModel: mainViewModel)
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            withTransaction(
                                Transaction(animation: .bouncy)
                            ) {
                                mainViewModel.changeMonth(
                                    by: -1,
                                    selectedDate: &mainViewModel.date
                                )
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                        Button {
                            withTransaction(
                                Transaction(animation: .bouncy)
                            ) {
                                mainViewModel.changeMonth(
                                    by: 1,
                                    selectedDate: &mainViewModel.date
                                )
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Today") {
                            withTransaction(
                                Transaction(animation: .bouncy)
                            ) {
                                mainViewModel.selectDate(
                                    Date(),
                                    selectedDate: &mainViewModel.date,
                                    isPresented: &mainViewModel
                                        .isExpandedCalendar
                                )
                            }
                        }
                        .font(.headline)
                    }
                }
        }
    }
}

#Preview {
    PreviewCalendarView.calendarView
}
