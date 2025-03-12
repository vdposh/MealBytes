//
//  SearchViewModel.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var favoriteFoods: [Food] = [] // Избранные продукты
    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            } else {
                debounceSearch(query)
            }
        }
    }
    @Published var errorMessage: AppError?
    @Published var currentPage: Int = 0
    @Published var maxResultsPerPage: Int = 20
    @Published var isLoading = false
    @Published private(set) var bookmarkedFoods: Set<String> = []
    @Published private(set) var squareFilledFoods: Set<String> = []
    
    private let networkManager: NetworkManagerProtocol
    private var searchCancellable: AnyCancellable?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    deinit {
        searchCancellable?.cancel()
    }
    
    // MARK: - Search
    func debounceSearch(_ query: String) {
        searchCancellable?.cancel()
        searchCancellable = $query
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                
                if query.isEmpty {
                    self.foods = self.favoriteFoods // Избранные продукты
                    self.errorMessage = nil
                    return
                }
                
                self.isLoading = true
                Task {
                    do {
                        let foods = try await self.networkManager
                            .fetchFoods(query: query,
                                        page: self.currentPage)
                        await MainActor.run {
                            self.foods = foods
                            self.errorMessage = nil
                            self.isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            switch error {
                            case let appError as AppError:
                                self.errorMessage = appError
                            default:
                                self.errorMessage = .networkError
                            }
                            self.isLoading = false
                        }
                    }
                }
            }
    }
    
    // MARK: - Pagination
    func loadNextPage() {
        isLoading = true
        currentPage += 1
        debounceSearch(query)
    }
    
    func loadPreviousPage() {
        if currentPage > 0 {
            isLoading = true
            currentPage -= 1
            debounceSearch(query)
        }
    }
    
    // MARK: - Reset Search
    func resetSearch() {
        currentPage = 0
        foods = favoriteFoods
        errorMessage = nil
        isLoading = false
    }
    
    // MARK: - Bookmark fill
    func toggleBookmark(for food: Food) {
        switch bookmarkedFoods.contains(food.searchFoodId) {
        case true:
            bookmarkedFoods.remove(food.searchFoodId)
        case false:
            bookmarkedFoods.insert(food.searchFoodId)
        }
    }
    
    func isBookmarked(_ food: Food) -> Bool {
        bookmarkedFoods.contains(food.searchFoodId)
    }
    
    // MARK: - Square fill
    func toggleSquareFill(for food: Food) {
        switch squareFilledFoods.contains(food.searchFoodId) {
        case true:
            squareFilledFoods.remove(food.searchFoodId)
        case false:
            squareFilledFoods.insert(food.searchFoodId)
        }
    }
    
    func isSquareFilled(_ food: Food) -> Bool {
        squareFilledFoods.contains(food.searchFoodId)
    }
}

#Preview {
    SearchView()
}
