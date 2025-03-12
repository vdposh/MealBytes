//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var currentPage: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    loadingView
                } else if viewModel.errorMessage != nil {
                    ContentUnavailableView.search(text: viewModel.query)
                } else {
                    List {
                        ForEach(viewModel.foods, id: \.searchFoodId) { food in
                            HStack {
                                NavigationLink(destination: FoodView(food: food)) {
                                    VStack(alignment: .leading) {
                                        Text(food.searchFoodName)
                                        if let parsedDescription = food.parsedDescription {
                                            Text(parsedDescription)
                                                .foregroundColor(.customGreen)
                                        }
                                    }
                                }
                                
                                Spacer(minLength: 20)
                                
                                if viewModel.query.isEmpty == false {
                                    Button(action: {
                                        viewModel.toggleBookmark(for: food)
                                    }) {
                                        Image(systemName: viewModel.isBookmarked(food) ? "bookmark.fill" : "bookmark")
                                            .foregroundColor(.customGreen)
                                            .imageScale(.large)
                                            .scaleEffect(x: 1.3, y: 1)
                                            .frame(width: 30, height: 30)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Spacer(minLength: 20)
                                    
                                    Button(action: {
                                        viewModel.toggleSquareFill(for: food)
                                    }) {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(viewModel.isSquareFilled(food) ? Color.customGreen : Color.clear)
                                            .frame(width: 22, height: 22)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 3)
                                                    .stroke(Color.customGreen, lineWidth: 1.75)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        
                        if !viewModel.foods.isEmpty {
                            if viewModel.foods.count == viewModel.maxResultsPerPage {
                                Button(action: {
                                    viewModel.loadNextPage()
                                }) {
                                    Text("> Next Page")
                                        .foregroundColor(.customGreen)
                                }
                            }
                            
                            if viewModel.currentPage > 0 {
                                Button(action: {
                                    viewModel.loadPreviousPage()
                                }) {
                                    Text("< Previous Page")
                                        .foregroundColor(.customGreen)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitle("Add to Diary", displayMode: .inline)
            .searchable(text: $viewModel.query)
        }
        .accentColor(.customGreen)
        .scrollDismissesKeyboard(.immediately)
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: .customGreen))
                .scaleEffect(1.5)
        }
    }
}

#Preview {
    SearchView()
}
