//
//  NotSetRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16.10.2026.
//

import SwiftUI

struct NotSetRow: View {
    let value: String
    var placeholder: String = "Not set"
    var placeholderIcon: String = "exclamationmark.triangle.fill"
    
    var body: some View {
        if value.isEmpty {
            Label {
                Text(placeholder)
            } icon: {
                Image(systemName: placeholderIcon)
                    .symbolRenderingMode(.multicolor)
            }
            .labelIconToTitleSpacing(10)
        } else {
            Text(value)
        }
    }
}
