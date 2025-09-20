//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            ZStack {
                if searchViewModel.isBookmarkedSearchView(food) {
                    Image(systemName: "bookmark.fill")
                        .imageScale(.small)
                        .foregroundStyle(.accent)
                }
            }
            .frame(width: 5)
            .padding(.trailing, 6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.searchFoodName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let parsedDescription = food.parsedDescription {
                    Text(parsedDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
