//
//  SearchViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var favoriteFoods: [Food] = []
    @Published var bookmarkedFoods: Set<Int> = []
    @Published var appError: AppError?
    @Published var foodToRemove: Food?
    @Published var selectedMealType: MealType = .breakfast
    @Published var showBookmarkDialog: Bool = false
    @Published var showMealType: Bool = false
    @Published var isLoading: Bool = false
    @Published var query: String = "" {
        didSet {
            guard query != oldValue else { return }
            currentPage = 0
            switch query.isEmpty {
            case true:
                resetSearch()
            case false:
                queueSearch(query)
            }
        }
    }
    
    var shouldResetQuery = false
    private var maxResultsPerPage: Int = 20
    private var currentPage: Int = 0
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModel
    
    private var searchCancellable: AnyCancellable?
    
    init(mainViewModel: MainViewModel) {
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
                    self.appError = nil
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
                            self.appError = nil
                            self.isLoading = false
                        }
                    } catch {
                        await MainActor.run {
                            switch error {
                            case let appError as AppError:
                                self.appError = appError
                            default:
                                self.appError = .network
                            }
                            self.isLoading = false
                        }
                    }
                }
            }
    }
    
    // MARK: - Load Bookmarks
    func loadBookmarksSearchView(for mealType: MealType) async {
        guard firebaseAuth.currentUserExists() else { return }
        
        await MainActor.run {
            selectedMealType = mealType
        }
        
        do {
            let favoriteFoods = try await firestore
                .loadBookmarksFirestore(for: mealType)
            let bookmarked = Set(favoriteFoods.map { $0.searchFoodId })
            
            await MainActor.run {
                self.favoriteFoods = favoriteFoods
                self.bookmarkedFoods = bookmarked
                if query.isEmpty {
                    self.foods = favoriteFoods
                }
                self.isLoading = false
                self.appError = nil
            }
        } catch {
            await MainActor.run {
                self.appError = .disconnected
                self.isLoading = false
            }
        }
    }
    
    func loadBookmarksData(for mealType: MealType) async {
        shouldResetQuery = true
        
        if shouldResetQuery {
            await MainActor.run {
                query = ""
                isLoading = true
            }
            shouldResetQuery = false
        }
        
        await loadBookmarksSearchView(for: mealType)
    }
    
    func mealSwitch(to meal: MealType) -> Bool {
        guard meal != selectedMealType else { return false }
        isLoading = true
        return true
    }
    
    // MARK: - Toggle Bookmark
    func toggleBookmarkSearchView(for food: Food) {
        Task {
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
            
            try await firestore.addBookmarkFirestore(updatedFavorites,
                                                     for: selectedMealType)
        }
    }
    
    // MARK: - Bookmark Management
    func isBookmarkedSearchView(_ food: Food) -> Bool {
        bookmarkedFoods.contains(food.searchFoodId)
    }
    
    func handleBookmarkAction(for food: Food) {
        if isBookmarkedSearchView(food) {
            foodToRemove = food
            showBookmarkDialog = true
        } else {
            toggleBookmarkSearchView(for: food)
        }
    }
    
    func confirmRemoveBookmark() {
        if let foodToRemove {
            toggleBookmarkSearchView(for: foodToRemove)
        }
        foodToRemove = nil
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
    private func resetSearch() {
        currentPage = 0
        foods = favoriteFoods
        appError = nil
        isLoading = false
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)
    
    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}

#Preview {
    NavigationStack {
        SearchView(
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mealType: .breakfast
        )
    }
}
