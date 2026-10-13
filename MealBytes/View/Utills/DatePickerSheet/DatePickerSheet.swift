//
//  DatePickerSheet.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/10/2026.
//

import SwiftUI

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationStack {
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .navigationTitle("Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .close) {
                        isPresented = false
                    } label: {
                        Text("Close")
                            .fontWeight(.medium)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        selectedDate = Date()
                    } label: {
                        Text("Today")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}
