//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Porshe on 19/03/2025.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current
    
    var body: some View {
        VStack {
            // Дни недели
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    let weekdayDate = calendar.date(byAdding: .day, value: index, to: startOfWeek())!
                    Text(weekdayDate.formatted(.dateTime.weekday(.short)))
                        .font(.footnote)
                        .foregroundColor(color(for: .weekday))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Даты текущего месяца
            let daysInMonth = daysForCurrentMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(daysInMonth, id: \.self) { date in
                    Button(action: {
                        selectedDate = date
                    }) {
                        Text("\(calendar.component(.day, from: date))")
                            .foregroundColor(color(for: .day, date: date))
                            .frame(width: 40, height: 40)
                            .background(isSelected(date) ? Color.customGreen.opacity(0.2) : .clear)
                            .cornerRadius(12)
                            .font(.callout)
                    }
                }
            }
        }
    }
    
    private func startOfWeek() -> Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }

    // Получение всех дат текущего месяца с пустыми днями в начале
    private func daysForCurrentMonth() -> [Date] {
        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: selectedDate)
        )!
        
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        let daysInMonth = range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        
        // Даты предыдущего месяца
        let firstWeekday = calendar.component(.weekday, from: startOfMonth) - 1
        let previousMonthDates = (0..<firstWeekday).compactMap { offset -> Date? in
            calendar.date(byAdding: .day, value: -(firstWeekday - offset), to: startOfMonth)
        }
        
        // Даты следующего месяца для завершения недели
        let daysToCompleteWeek = 7 - ((daysInMonth.count + firstWeekday) % 7)
        let nextMonthDates = (1...daysToCompleteWeek).compactMap { offset -> Date? in
            calendar.date(byAdding: .day, value: offset, to: daysInMonth.last!)
        }
        
        return previousMonthDates + daysInMonth + nextMonthDates
    }
    
    // Проверка, является ли день выбранным
    private func isSelected(_ date: Date) -> Bool {
        calendar.isDate(selectedDate, inSameDayAs: date)
    }
    
    // Определение цвета для элементов
    private func color(for element: DisplayElement, date: Date? = nil) -> Color {
        if let date = date {
            if isSelected(date) || calendar.isDateInToday(date) {
                return .customGreen
            }
            if calendar.component(.month, from: date) != calendar.component(.month, from: selectedDate) {
                return .secondary // Цвет для дней из других месяцев
            }
        }
        
        switch element {
        case .day:
            return .primary
        case .weekday:
            return .secondary
        }
    }
}

enum DisplayElement {
    case day
    case weekday
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
