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
            
            ForEach(nutrients) { nutrient in
                DetailedNutrientRow(nutrient: nutrient)
            }
            
            ShowHideButtonView(isExpanded: isExpanded) {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        }
    }
}
