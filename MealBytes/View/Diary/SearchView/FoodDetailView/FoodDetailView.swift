//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    let isEditing: Bool
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            if !isEditing {
                ZStack {
                    if searchViewModel.isBookmarkedSearchView(food) {
                        Image(systemName: "bookmark.fill")
                            .imageScale(.small)
                            .foregroundStyle(.accent)
                    }
                }
                .frame(width: 5)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(food.searchFoodName)
                
                if let parsedDescription = food.parsedDescription {
                    Text(parsedDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PreviewContentView.contentView
}
