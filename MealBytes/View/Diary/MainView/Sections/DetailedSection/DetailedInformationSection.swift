//
//  DetailedInformationSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct DetailedInformationSection: View {
    @Binding var isExpanded: Bool
    let nutrients: [DetailedNutrient]
    
    var body: some View {
        Section {
            Text("Detailed Information")
                .font(.callout)
                .fontWeight(.medium)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            ForEach(nutrients, id: \.id) { nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundColor(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(nutrient.formattedValue)
                        .foregroundColor(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
            ShowHideButtonView(isExpanded: $isExpanded)
        }
    }
}
