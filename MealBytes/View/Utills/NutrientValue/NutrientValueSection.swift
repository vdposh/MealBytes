//
//  NutrientValueSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/09/2025.
//

import SwiftUI

struct NutrientValueSection: View {
    let title: String
    let nutrients: [NutrientValue]
    let isExpandable: Binding<Bool>?
    
    var body: some View {
        Section {
            Text(title)
                .fontWeight(.medium)
                .listRowSeparator(.hidden)
                .padding(.top, 6)
            
            ForEach(nutrients) { nutrient in
                HStack {
                    Text(nutrient.type.title)
                        .foregroundStyle(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(nutrient.formattedValue)
                        .foregroundStyle(
                            nutrient.isSubValue ? .secondary : .primary
                        )
                        .font(.subheadline)
                        .lineLimit(1)
                }
            }
            
            if let isExpandable {
                ShowHideButtonView(isExpanded: isExpandable)
            }
        }
    }
}
