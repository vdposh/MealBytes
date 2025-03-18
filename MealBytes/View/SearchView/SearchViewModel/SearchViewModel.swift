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
    @Published var favoriteFoods: [Food] = []
    @Published var bookmarkedFoods: Set<Int> = []
    @Published var query: String = "" {
        didSet {
            switch query.isEmpty {
            case true:
                resetSearch()
            case false:
                debounceSearch(query)
            }
        }
    }
    @Published var errorMessage: AppError?
    @Published var currentPage: Int = 0
    @Published var maxResultsPerPage: Int = 20
    @Published var isLoading = false
    
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
                    self.foods = self.favoriteFoods
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
    enum PageDirection {
        case next
        case previous
    }
    
    func canLoadPage(direction: PageDirection) -> Bool {
        switch direction {
        case .next:
            foods.count == maxResultsPerPage
        case .previous:
            currentPage > 0
        }
    }
    
    func loadPage(direction: PageDirection) {
        isLoading = true
        switch direction {
        case .next:
            currentPage += 1
        case .previous:
            if currentPage > 0 {
                currentPage -= 1
            }
        }
        debounceSearch(query)
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
            favoriteFoods.removeAll { $0.searchFoodId == food.searchFoodId }
        case false:
            bookmarkedFoods.insert(food.searchFoodId)
            favoriteFoods.append(food)
        }
    }
    
    func isBookmarked(_ food: Food) -> Bool {
        bookmarkedFoods.contains(food.searchFoodId)
    }
}

#Preview {
    SearchView(
        isPresented: .constant(true),
        mainViewModel: MainViewModel(),
        mealType: .breakfast
    )
}
