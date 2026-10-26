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
    var onConfirm: (() -> Void)? = nil
    
    private var hasConfirm: Bool {
        onConfirm != nil
    }
    
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
                if hasConfirm {
                    ToolbarItem {
                        Button(role: .confirm) {
                            onConfirm?()
                            isPresented = false
                        }
                    }
                } else {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .close) {
                            isPresented = false
                        } label: {
                            Text("Close")
                                .fontWeight(.medium)
                        }
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button("Today") {
                        selectedDate = Date()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
