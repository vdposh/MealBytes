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
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.tertiary)
                }
                .padding(.trailing, 2)
            } label: {
                Label {
                    Text("Date")
                        .foregroundStyle(Color.primary)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundStyle(.customGray)
                }
            }
        }
    }
}
