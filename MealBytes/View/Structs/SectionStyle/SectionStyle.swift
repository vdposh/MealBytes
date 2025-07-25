//
//  SectionStyle.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct SectionStyleContainer<Content: View>: View {
    var mainContent: Content
    var secondaryContent: AnyView?
    var layout: SectionCardLayout
    var title: String?
    var description: String?
    var useWideTrailingPadding: Bool = false
    var hasBottomPadding: Bool = true
    var hasTopTextPadding: Bool = true
    var useLargeCornerRadius: Bool = false
    var useCompactVerticalPadding: Bool = false
    
    init(
        @ViewBuilder mainContent: () -> Content,
        @ViewBuilder secondaryContent: () -> AnyView? = { nil },
        layout: SectionCardLayout = .textStyle,
        title: String? = nil,
        description: String? = nil,
        useWideTrailingPadding: Bool = false,
        hasBottomPadding: Bool = true,
        hasTopTextPadding: Bool = true,
        useLargeCornerRadius: Bool = false,
        useCompactVerticalPadding: Bool = false
    ) {
        self.mainContent = mainContent()
        self.secondaryContent = secondaryContent()
        self.layout = layout
        self.title = title
        self.description = description
        self.useWideTrailingPadding = useWideTrailingPadding
        self.hasBottomPadding = hasBottomPadding
        self.hasTopTextPadding = hasTopTextPadding
        self.useLargeCornerRadius = useLargeCornerRadius
        self.useCompactVerticalPadding = useCompactVerticalPadding
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .font(.footnote)
                    .lineSpacing(-2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            switch layout {
            case .pickerStyle:
                mainContent
                    .padding(.vertical, useCompactVerticalPadding ? 5 : 6.5)
                    .padding(.leading, 16)
                    .padding(.trailing, useWideTrailingPadding ? 16 : 4)
                    .background(
                        Color(.secondarySystemGroupedBackground)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                
            case .pickerUnitStyle:
                VStack {
                    mainContent
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    
                    if let secondary = secondaryContent {
                        secondary
                            .padding(.leading, 16)
                            .padding(.trailing, 4)
                            .padding(.top, 2)
                            .padding(.bottom, 10)
                    }
                }
                .background(
                    Color(.secondarySystemGroupedBackground)
                )
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
            case .textStyle:
                mainContent
                    .padding(.horizontal, 16)
                    .padding(.top, hasTopTextPadding ? 12 : 18)
                    .padding(.bottom)
                    .background(
                        Color(.secondarySystemGroupedBackground)
                    )
                    .cornerRadius(useLargeCornerRadius ? 12 : 10)
                    .padding(.horizontal, 16)
                
            case .resultRdiStyle:
                mainContent
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal, 32)
            }
            
            if let description {
                Text(description)
                    .font(.footnote)
                    .lineSpacing(-2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)
            }
        }
        .padding(.bottom, hasBottomPadding ? 23 : 0)
    }
}

enum SectionCardLayout {
    case pickerStyle
    case pickerUnitStyle
    case textStyle
    case resultRdiStyle
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

#Preview {
    let mainViewModel = MainViewModel()
    let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
    
    return NavigationStack {
        RdiView(rdiViewModel: rdiViewModel)
    }
}
