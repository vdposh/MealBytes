//
//  NutrientDetailSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientDetailSection: View {
    let title: String
    let nutrientDetails: [NutrientDetail]
    
    var body: some View {
        SectionStyleContainer(
            mainContent: {
                VStack(alignment: .leading, spacing: 14) {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.medium)
                        .padding(.bottom, 6)
                        .padding(.horizontal, 4)
                    
                    ForEach(
                        Array(nutrientDetails.enumerated()),
                        id: \.1.id
                    ) { index, nutrient in
                        HStack {
                            Text(nutrient.type.title)
                                .foregroundColor(
                                    nutrient.isSubValue ? .secondary : .primary
                                )
                                .font(.subheadline)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            
                            Text(nutrient.formattedValue)
                                .foregroundColor(
                                    nutrient.isSubValue ? .secondary : .primary
                                )
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        
                        if index < nutrientDetails.count - 1 {
                            Divider()
                                .padding(.trailing, -21)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                
            },
            layout: .textStyle,
            hasTopTextPadding: false,
            useLargeCornerRadius: true
        )
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        FoodView(
            navigationTitle: "Add to Diary",
            food: Food(
                searchFoodId: 3092,
                searchFoodName: "Egg",
                searchFoodDescription: "1 cup"
            ),
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mainViewModel: MainViewModel(),
            mealType: .breakfast,
            amount: "1",
            measurementDescription: "Grams",
            showAddButton: false,
            showSaveRemoveButton: true,
            showMealTypeButton: true,
            originalMealItemId: UUID()
        )
    }
}
