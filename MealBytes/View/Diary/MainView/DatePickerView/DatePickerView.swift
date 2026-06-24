//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/05/2026.
//

import SwiftUI

struct DatePickerView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            DatePicker(
                "Select Date",
                selection: $mainViewModel.date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            
            Button {
                mainViewModel.date = Date()
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
