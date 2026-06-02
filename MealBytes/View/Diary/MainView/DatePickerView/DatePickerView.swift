//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/05/2026.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var date: Date
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
        }
        .frame(width: 320)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    PreviewContentView.contentView
}
