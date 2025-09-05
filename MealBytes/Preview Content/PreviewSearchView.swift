//
//  PreviewSearchView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewSearchView {
    static var searchView: some View {
        let mainViewModel = MainViewModel()
        let searchViewModel = SearchViewModel(mainViewModel: mainViewModel)
        
        return NavigationStack {
            SearchView(
                searchViewModel: searchViewModel,
                mealType: .breakfast
            )
        }
    }
}

#Preview {
    PreviewSearchView.searchView
}
