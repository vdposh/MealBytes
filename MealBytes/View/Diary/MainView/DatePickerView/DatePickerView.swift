//
//  DatePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/05/2026.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var date: Date
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 0) {
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
                    .padding(4)
            }
            .buttonStyle(.glass)
            .padding(.bottom, 20)
        }
        .frame(width: 320)
        .padding(.horizontal)
        .padding(.top, 8)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    PreviewContentView.contentView
}
