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
    @Published var errorMessage: AppError?
    @Published var currentPage: Int = 0
    @Published var maxResultsPerPage: Int = 20
    @Published var isLoading = false
    @Published var query: String = "" {
        didSet {
            switch query.isEmpty {
            case true:
                resetSearch()
            case false:
                queueSearch(query)
            }
        }
    }
    
    private let networkManager: NetworkManagerProtocol
    private let firestoreManager: FirestoreManagerProtocol
    private var searchCancellable: AnyCancellable?
    let mainViewModel: MainViewModel
    
    init(networkManager: NetworkManagerProtocol = NetworkManager(),
         firestoreManager: FirestoreManagerProtocol = FirestoreManager(),
         mainViewModel: MainViewModel) {
        self.networkManager = networkManager
        self.firestoreManager = firestoreManager
        self.mainViewModel = mainViewModel
    }
    
    deinit {
        searchCancellable?.cancel()
    }
    
    // MARK: - Search
    func queueSearch(_ query: String) {
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
                                self.errorMessage = .network
                            }
                            self.isLoading = false
                        }
                    }
                }
            }
    }
    
    // MARK: - Delete Meal Item
    func loadBookmarksSearchView() {
        Task {
            do {
                let bookmarkedIds = try await firestoreManager
                    .loadBookmarksFirebase()
                await MainActor.run {
                    bookmarkedFoods = Set(bookmarkedIds)
                }
            }
        }
    }
    
    // MARK: - Bookmark fill
    func toggleBookmarkSearchView(for food: Food) {
        Task {
            do {
                switch bookmarkedFoods.contains(food.searchFoodId) {
                case true:
                    await MainActor.run {
                        bookmarkedFoods.remove(food.searchFoodId)
                        favoriteFoods.removeAll {
                            $0.searchFoodId == food.searchFoodId
                        }
                    }
                    try await firestoreManager
                        .removeBookmarkFirebase(food: food)
                case false:
                    await MainActor.run {
                        bookmarkedFoods.insert(food.searchFoodId)
                        favoriteFoods.append(food)
                    }
                    try await firestoreManager
                        .saveBookmarkFirebase(food: food)
                }
            }
        }
    }
    
    func isBookmarkedSearchView(_ food: Food) -> Bool {
        bookmarkedFoods.contains(food.searchFoodId)
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
        queueSearch(query)
    }
    
    // MARK: - Reset Search
    func resetSearch() {
        currentPage = 0
        foods = favoriteFoods
        errorMessage = nil
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        SearchView(
            isPresented: .constant(true),
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mealType: .breakfast
        )
    }
    .accentColor(.customGreen)
}
