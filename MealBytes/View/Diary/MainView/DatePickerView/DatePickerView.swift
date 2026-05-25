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
            
            Button {
                date = Date()
            } label: {
                Text("Today")
                    .fontWeight(.medium)
            }
        }
        .frame(width: 320)
        .padding(.horizontal)
        .padding(.top, 6)
        .padding(.bottom, 24)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    PreviewContentView.contentView
}
