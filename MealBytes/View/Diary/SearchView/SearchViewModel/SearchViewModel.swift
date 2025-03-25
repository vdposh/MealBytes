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
    private var maxResultsPerPage: Int = 20
    var currentPage: Int = 0
    
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
    func loadBookmarksSearchView() async {
        do {
            let favoriteFoods = try await firestoreManager
                .loadBookmarksFirebase()

            let bookmarked = Set(favoriteFoods.map { $0.searchFoodId })

            await MainActor.run {
                self.favoriteFoods = favoriteFoods
                self.foods = favoriteFoods
                self.bookmarkedFoods = bookmarked
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error as? AppError ?? .network
            }
        }
    }
    
    // MARK: - Bookmark fill
    func toggleBookmarkSearchView(for food: Food) {
        Task {
            let isAdding = !bookmarkedFoods.contains(food.searchFoodId)
            
            let updatedBookmarkedFoods = isAdding
            ? bookmarkedFoods.union([food.searchFoodId])
            : bookmarkedFoods.subtracting([food.searchFoodId])
            
            let updatedFavorites: [Food] = isAdding
            ? favoriteFoods + (favoriteFoods.contains {
                $0.searchFoodId == food.searchFoodId } ? [] : [food])
            : favoriteFoods.filter { $0.searchFoodId != food.searchFoodId }
            
            await MainActor.run {
                self.favoriteFoods = updatedFavorites
                self.bookmarkedFoods = updatedBookmarkedFoods
            }
            
            try await firestoreManager.addBookmarkFirebase(updatedFavorites)
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
