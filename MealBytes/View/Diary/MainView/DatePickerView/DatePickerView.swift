//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/05/2026.
//

import SwiftUI

struct DatePickerView: View {
    @State private var selectedDate: Date
    @ObservedObject var mainViewModel: MainViewModel
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
        self._selectedDate = State(initialValue: mainViewModel.date)
    }
    
    var body: some View {
        DatePicker(
            "Select Date",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(.graphical)
        .frame(width: 340)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .presentationCompactAdaptation(.popover)
        .onChange(of: selectedDate) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                mainViewModel.setDate(selectedDate)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
