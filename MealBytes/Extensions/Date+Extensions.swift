//
//  Date+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19.10.2026.
//

import Foundation

extension Date {
    enum RelativeDay: String {
        case today = "today"
        case yesterday = "yesterday"
        case tomorrow = "tomorrow"
        case none = ""
    }
    
    var relativeDay: RelativeDay {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return .today
        }
        
        if calendar.isDateInYesterday(self) {
            return .yesterday
        }
        
        if calendar.isDateInTomorrow(self) {
            return .tomorrow
        }
        
        return .none
    }
    
    func formattedWeekdayDate() -> String {
        let calendar = Calendar.current
        
        if calendar.isDate(self, equalTo: Date(), toGranularity: .year) {
            return formatted(
                .dateTime.weekday(.wide).day().month(.wide)
            )
        } else {
            return formatted(
                .dateTime.weekday(.abbreviated).day().month(.wide).year()
            )
        }
    }
}
