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
            
            ForEach(
                Array(nutrients.enumerated()),
                id: \.element.id
            ) { index, nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundStyle(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                    
                    Text(nutrient.formattedValue)
                        .foregroundStyle(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .lineLimit(1)
                }
                .overlay(alignment: .top) {
                    if index != 0 {
                        SeparatorView()
                    }
                }
            }
            
            ShowHideButtonView(isExpanded: $isExpanded)
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PreviewContentView.contentView
}
