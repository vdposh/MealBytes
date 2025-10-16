//
//  MealTypePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 11/10/2025.
//

import SwiftUI

struct MealTypePickerView: View {
    private var iconName: String {
        selectedMealType.iconName
    }
    @Binding var selectedMealType: MealType
    
    var body: some View {
        HStack {
            Label {
                Text(selectedMealType.rawValue)
            } icon: {
                Image(systemName: iconName)
                    .font(.system(size: 14))
                    .foregroundStyle(.accent.opacity(0.8))
            }
            .labelIconToTitleSpacing(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Menu {
                Picker("Meal Type", selection: $selectedMealType) {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Label(
                            meal.rawValue,
                            systemImage: meal.iconName
                        )
                        .tag(meal)
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.2))
                        .frame(width: 30, height: 30)
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.accent)
                }
            }
            .glassEffect(.regular.interactive())
            .buttonStyle(.borderless)
        }
        .frame(height: 20)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
