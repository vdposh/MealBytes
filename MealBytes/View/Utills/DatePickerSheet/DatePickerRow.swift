//
//  DatePickerRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/10/2026.
//

import SwiftUI

struct DatePickerRow: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            LabeledContent {
                HStack(spacing: 10) {
                    Text(selectedDate.formattedWeekdayDate())
                        .lineLimit(1)
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.placeholderText))
                        .padding(.trailing, 2)
                }
            } label: {
                Text("Date")
                    .foregroundStyle(Color.primary)
            }
        }
    }
}
