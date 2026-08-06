//
//  HeaderButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 31.07.2026.
//

import SwiftUI

struct HeaderButtonView: View {
    let mealType: MealType
    let title: String
    let calories: Double?
    let fat: Double?
    let carbs: Double?
    let protein: Double?
    let hasItems: Bool
    let isExpanded: Bool
    let showNutrients: Bool
    let isEdit: Bool
    let action: () -> Void
    
    init(
        mealType: MealType,
        title: String,
        calories: Double? = nil,
        fat: Double? = nil,
        carbs: Double? = nil,
        protein: Double? = nil,
        hasItems: Bool = false,
        isExpanded: Bool = false,
        showNutrients: Bool = false,
        isEdit: Bool = false,
        action: @escaping () -> Void
    ) {
        self.mealType = mealType
        self.title = title
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.hasItems = hasItems
        self.isExpanded = isExpanded
        self.showNutrients = showNutrients
        self.isEdit = isEdit
        self.action = action
    }
    
    var body: some View {
        if showNutrients {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        HeaderTextView(mealType: mealType, title: title)
                        
                        if hasItems && showNutrients,
                           let calories, let fat, let carbs, let protein {
                            NutrientSummaryView(
                                calories: calories,
                                fat: fat,
                                carbs: carbs,
                                protein: protein
                            )
                        }
                    }
                    
                    if hasItems {
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(.accent)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                            .animation(.default, value: isExpanded)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .listRowInsets(.all, 0)
            .buttonStyle(ButtonStyleInvisible())
        } else {
            HStack {
                HeaderTextView(mealType: mealType, title: title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                
                if isEdit {
                    Button {
                        withAnimation {
                            action()
                        }
                    } label: {
                        Text("Edit")
                            .fontWeight(.regular)
                            .foregroundStyle(.accent)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .buttonStyle(.borderless)
                }
            }
            .transaction { $0.animation = nil }
            .listRowInsets(.all, 0)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
