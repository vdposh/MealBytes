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
        VStack(spacing: 0) {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .onChange(of: selectedDate) {
                withAnimation {
                    mainViewModel.date = selectedDate
                }
            }
            
            Button {
                withAnimation {
                    mainViewModel.date = Date()
                }
            } label: {
                Text("Today")
                    .fontWeight(.medium)
                    .foregroundStyle(
                        mainViewModel.isTodaySelected ? .primary
                            .opacity(1) : Color.primary
                    )
                    .padding(6)
            }
            .buttonStyle(.glass)
            .disabled(mainViewModel.isTodaySelected)
            .padding(.bottom, 8)
        }
        .frame(width: 320)
        .padding(.horizontal)
        .padding(.bottom, 8)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    PreviewContentView.contentView
}
