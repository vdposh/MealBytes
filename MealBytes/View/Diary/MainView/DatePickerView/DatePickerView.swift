//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/05/2026.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var date: Date
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            DatePicker(
                "Select Date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .onChange(of: date) {
                dismiss()
            }
            
            Button {
                date = Date()
                dismiss()
            } label: {
                Text("Today")
                    .fontWeight(.medium)
            }
        }
        .frame(width: 320)
        .padding(.horizontal)
        .padding(.top, 6)
        .padding(.bottom, 26)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    PreviewContentView.contentView
}
