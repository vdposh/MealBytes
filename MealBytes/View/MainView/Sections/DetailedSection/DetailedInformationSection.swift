//
//  DetailedInformationSection.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct DetailedInformationSection: View {
    let nutrients: [DetailedNutrient]
    @Binding var isExpanded: Bool

    var body: some View {
        Section {
            Text("Detailed Information")
                .fontWeight(.medium)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            ForEach(nutrients, id: \.id) { nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundColor(nutrient.isSubValue ? .gray : .primary)
                        .font(.subheadline)
                    Spacer()
                    Text(nutrient.formattedValue)
                        .foregroundColor(nutrient.isSubValue ? .gray : .primary)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
            
            ShowHideButtonView(isExpanded: $isExpanded)
        }
    }
}
