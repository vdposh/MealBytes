//
//  MealTypePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 11/10/2025.
//

import SwiftUI

struct MealTypePickerView: View {
    let description: String
    let iconName: String
    let iconColor: Color = .accent.opacity(0.8)
    @Binding var selectedMealType: MealType
    
    var body: some View {
        HStack {
            Label {
                Text(description)
            } icon: {
                Image(systemName: iconName)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
            }
            .labelIconToTitleSpacing(10)
            .frame(maxWidth: .infinity, minHeight: 27, alignment: .leading)
            
            Text("")
                .frame(maxWidth: 30, alignment: .trailing)
            
                .overlay(alignment: .trailing) {
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
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
