//
//  HeaderButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 31.07.2026.
//

import SwiftUI

struct HeaderButtonView: View {
    let title: String
    var calories: Double? = nil
    var fat: Double? = nil
    var carbs: Double? = nil
    var protein: Double? = nil
    var hasItems: Bool = false
    var isExpanded: Bool = false
    var showNutrients: Bool = false
    var isEdit: Bool = false
    let action: () -> Void
    
    var body: some View {
        if showNutrients {
            Button {
                withAnimation {
                    action()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        HeaderTextView(title: title)
                        
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
                .padding(
                    .horizontal,
                    UIScreen.horizontalPadding(focused: true)
                )
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .listRowInsets(.all, 0)
            .buttonStyle(InvisibleButtonStyle())
        } else {
            HStack {
                HeaderTextView(title: title)
                    .padding(
                        .horizontal,
                        UIScreen.horizontalPadding(focused: true)
                    )
                    .padding(.vertical, 10)
                
                if isEdit {
                    Button {
                        action()
                    } label: {
                        Text("Edit")
                            .fontWeight(.regular)
                            .foregroundStyle(.accent)
                    }
                    .padding(
                        .horizontal,
                        UIScreen.horizontalPadding(focused: true)
                    )
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
