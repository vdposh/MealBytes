//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Porshe on 19/03/2025.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    let mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button("Today") {
                    selectDate(Date())
                }
                
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "chevron.left")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
                
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.headline)
            .padding(.bottom)
            .padding(.horizontal)
            
            HStack {
                if let startOfWeek = mainViewModel.calendar.date(
                    from: mainViewModel.calendar.dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: Date()
                    )
                ) {
                    ForEach(mainViewModel.calendar.weekdaySymbols.indices,
                            id: \.self) { index in
                        if let weekdayDate = mainViewModel.calendar.date(
                            byAdding: .day, value: index, to: startOfWeek
                        ) {
                            Text(weekdayDate.formatted(
                                .dateTime.weekday(.short)))
                            .font(.footnote)
                            .foregroundColor(
                                mainViewModel.color(
                                    for: .weekday, date: weekdayDate
                                )
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
                                     count: 7)) {
                ForEach(daysForCurrentMonth(), id: \.self) { date in
                    Button(action: { selectDate(date) }) {
                        Text("\(mainViewModel.calendar.component(.day, from: date))")
                            .foregroundColor(
                                mainViewModel.color(
                                    for: .day,
                                    date: date,
                                    isSelected: mainViewModel.calendar.isDate(
                                        selectedDate,
                                        inSameDayAs: date
                                    ),
                                    isToday: mainViewModel.calendar
                                        .isDateInToday(date)
                                )
                            )
                            .frame(width: 40, height: 40)
                            .background(
                                mainViewModel.color(
                                    for: .day,
                                    date: date,
                                    isSelected: mainViewModel.calendar.isDate(
                                        selectedDate,
                                        inSameDayAs: date
                                    ),
                                    forBackground: true
                                )
                            )
                            .cornerRadius(12)
                            .font(.callout)
                    }
                }
            }
        }
        .padding()
    }
    
    private func selectDate(_ date: Date) {
        selectedDate = date
        isPresented = false
    }
    
    private func changeMonth(by value: Int) {
        if let newDate = mainViewModel.calendar.date(
            byAdding: .month, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    private func daysForCurrentMonth() -> [Date] {
        guard let startOfMonth = mainViewModel.calendar.date(
            from: mainViewModel.calendar.dateComponents(
                [.year, .month], from: selectedDate)
        ),
              let range = mainViewModel.calendar.range(
                of: .day, in: .month, for: startOfMonth)
        else { return [] }
        
        let daysInMonth = range.compactMap {
            mainViewModel.calendar.date(
                byAdding: .day, value: $0 - 1, to: startOfMonth)
        }
        
        let firstWeekday = max(mainViewModel.calendar.component(
            .weekday, from: startOfMonth) - 2, 0)
        let previousMonthDates = (0..<firstWeekday).reversed().compactMap {
            mainViewModel.calendar.date(
                byAdding: .day, value: -$0 - 1, to: startOfMonth)
        }
        
        let remainingDays = max(0, (7 - (daysInMonth.count + firstWeekday) % 7))
        let nextMonthDates: [Date] = remainingDays > 0
        ? (1...remainingDays).compactMap { offset in
            guard let lastDay = daysInMonth.last else { return nil }
            return mainViewModel.calendar.date(
                byAdding: .day, value: offset, to: lastDay)
        }
        : []
        
        return previousMonthDates + daysInMonth + nextMonthDates
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
