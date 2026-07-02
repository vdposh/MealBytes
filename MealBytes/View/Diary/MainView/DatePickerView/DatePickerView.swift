//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/05/2026.
//

import SwiftUI

struct DatePickerView: View {
    @State private var selectedDate: Date
    @Binding var date: Date
    
    private let today = Date()
    
    init(date: Binding<Date>) {
        self._date = date
        self._selectedDate = State(initialValue: date.wrappedValue)
    }
    
    var body: some View {
        DatePicker(
            "Select Date",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .frame(width: 320)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .presentationCompactAdaptation(.popover)
        .onChange(of: selectedDate) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    date = selectedDate
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
