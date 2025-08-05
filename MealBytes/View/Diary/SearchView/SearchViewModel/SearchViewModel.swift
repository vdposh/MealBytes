//
//  SearchViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Combine

protocol SearchViewModelProtocol {
    func toggleBookmarkSearchView(for food: Food) async
    func loadBookmarksData(for mealType: MealType) async
    func isBookmarkedSearchView(_ food: Food) -> Bool
}

final class SearchViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var favoriteFoods: [Food] = []
    @Published var bookmarkedFoods: Set<Int> = []
    @Published var appError: AppError?
    @Published var foodToRemove: Food?
    @Published var selectedMealType: MealType = .breakfast
    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            }
        }
    }
    @Published var showBookmarkDialog: Bool = false
    @Published var showMealType: Bool = false
    @Published var isLoading: Bool = false
    
    private var maxResultsPerPage: Int = 20
    private var currentPage: Int = 0
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        setupBindingsSearchView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Search
    private func setupBindingsSearchView() {
        $query
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                guard let self else { return }
                self.currentPage = 0
                self.performSearch(query)
            }
            .store(in: &cancellables)
    }
    
    func performSearch(_ query: String) {
        if query.isEmpty {
            foods = favoriteFoods
            appError = nil
            isLoading = false
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let foods = try await networkManager.fetchFoods(
                    query: query,
                    page: currentPage
                )
                await MainActor.run {
                    self.foods = foods
                    self.appError = nil
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case let appError as AppError:
                        self.appError = appError
                    default: self.appError = .networkRefresh
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    private func resetSearch() {
        currentPage = 0
        foods = favoriteFoods
        appError = nil
        isLoading = false
    }
    
    // MARK: - Load Bookmarks Data
    func loadBookmarksSearchView(for mealType: MealType) async {
        guard firebaseAuth.currentUserExists() else { return }
        
        await MainActor.run {
            selectedMealType = mealType
        }
        
        do {
            let favorites = try await firestore.loadBookmarksFirestore(
                for: mealType
            )
            let bookmarked = Set(favorites.map { $0.searchFoodId })
            await MainActor.run {
                self.favoriteFoods = favorites
                self.bookmarkedFoods = bookmarked
                if query.isEmpty {
                    self.foods = favorites
                }
                self.isLoading = false
                self.appError = nil
            }
        } catch {
            await MainActor.run {
                self.appError = .network
                self.isLoading = false
            }
        }
    }
    
    func loadBookmarksData(for mealType: MealType) async {
        await MainActor.run {
            query = ""
            isLoading = true
        }
        await loadBookmarksSearchView(for: mealType)
    }
    
    func mealSwitch(to meal: MealType) -> Bool {
        guard meal != selectedMealType else { return false }
        isLoading = true
        return true
    }
    
    // MARK: - Toggle Bookmark
    func toggleBookmarkSearchView(for food: Food) async {
        let isAdding = !bookmarkedFoods.contains(food.searchFoodId)
        
        let updatedBookmarkedFoods: Set<Int>
        if isAdding {
            updatedBookmarkedFoods = bookmarkedFoods
                .union([food.searchFoodId])
        } else {
            updatedBookmarkedFoods = bookmarkedFoods
                .subtracting([food.searchFoodId])
        }
        
        let updatedFavorites: [Food]
        if isAdding {
            if !favoriteFoods.contains(food) {
                updatedFavorites = favoriteFoods + [food]
            } else {
                updatedFavorites = favoriteFoods
            }
        } else {
            updatedFavorites = favoriteFoods.filter { $0 != food }
        }
        
        await MainActor.run {
            self.favoriteFoods = updatedFavorites
            self.bookmarkedFoods = updatedBookmarkedFoods
            if query.isEmpty {
                self.foods = updatedFavorites
            } else {
                self.foods = self.foods
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                updatedFavorites,
                for: selectedMealType
            )
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Bookmark Management
    func isBookmarkedSearchView(_ food: Food) -> Bool {
        bookmarkedFoods.contains(food.searchFoodId)
    }
    
    func handleBookmarkAction(for food: Food) async {
        if isBookmarkedSearchView(food) {
            await MainActor.run {
                foodToRemove = food
                showBookmarkDialog = true
            }
        } else {
            await toggleBookmarkSearchView(for: food)
        }
    }
    
    func confirmRemoveBookmark() async {
        if let foodToRemove {
            await toggleBookmarkSearchView(for: foodToRemove)
        }
        
        await MainActor.run {
            foodToRemove = nil
        }
    }
    
    var bookmarkTitle: String {
        guard let foodName = foodToRemove?.searchFoodName else {
            return ""
        }
        return "Remove \"\(foodName)\" from favorite foods?"
    }
    
    // MARK: - Pagination
    enum PageDirection {
        case next
        case previous
    }
    
    func canLoadPage(direction: PageDirection) -> Bool {
        switch direction {
        case .next: foods.count == maxResultsPerPage
        case .previous: currentPage > 0
        }
    }
    
    func loadPage(direction: PageDirection) {
        isLoading = true
        switch direction {
        case .next: currentPage += 1
        case .previous:
            if currentPage > 0 {
                currentPage -= 1
            }
        }
        performSearch(query)
    }
}

extension SearchViewModel: SearchViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        SearchView(
            searchViewModel: SearchViewModel(
                mainViewModel: MainViewModel()
            ),
            mealType: .breakfast
        )
    }
}
