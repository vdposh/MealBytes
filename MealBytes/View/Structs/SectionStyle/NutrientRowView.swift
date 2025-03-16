//
//  NutrientRowView.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientRowView: View {
    let title: String
    let value: String
    let isSubValue: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isSubValue ? .gray : .primary)
                .font(.subheadline)
            Spacer()
            Text(value)
                .foregroundColor(isSubValue ? .gray : .primary)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
}
