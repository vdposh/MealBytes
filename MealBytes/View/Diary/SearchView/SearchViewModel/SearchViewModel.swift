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
    func loadBookmarksSearchView(for mealType: MealType) async
    func loadBookmarks() async
    func updateMetadata(
        _ metadata: FoodMetadata,
        for mealType: MealType
    )
    func displayBookmarks(for mealType: MealType)
    func addToHistory(_ food: Food, for mealType: MealType) async
    func isBookmarkedSearchView(_ food: Food) -> Bool
    func triggerFoodAlert()
    func resetQuery()
    
    var foodMetadataDict: [Int: FoodMetadata] { get set }
}

final class SearchViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var favoriteFoods: [Food] = []
    @Published var historyFoods: [Food] = []
    @Published var bookmarkedFoods: Set<Int> = []
    @Published var foodMetadataDict: [Int: FoodMetadata] = [:]
    @Published var selectedItems = Set<Food.ID>()
    @Published var appError: AppError?
    @Published var uniqueId: UUID?
    @Published var selectedMealType: MealType = .breakfast
    @Published var editingState: EditingState = .inactive
    @Published var debouncedQuery: String = ""
    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            }
        }
    }
    @Published var showMealType: Bool = false
    @Published var isLoading: Bool = false
    @Published var showRemoveDialog: Bool = false
    @Published var isFoodAddedAlertVisible: Bool = false
    @Published var isAlertInProgress: Bool = false
    
    private var bookmarksByType: [MealType: [Food]] = [:]
    private var bookmarkedIdsByType: [MealType: Set<Int>] = [:]
    private var metadataByType: [MealType: [Int: FoodMetadata]] = [:]
    
    private var historyByType: [MealType: [Food]] = [:]
    private let maxHistoryCount = 10
    
    private var maxResultsPerPage: Int = 20
    private var currentPage: Int = 0
    
    private let fatSecretManager: FatSecretManagerProtocol = FatSecretManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    
    private var currentTask: Task<Void, Never>?
    private var currentSearchTask: Task<Void, Never>?
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
            .sink { [weak self] query in
                self?.debouncedQuery = query
                
                if !query.isEmpty {
                    self?.currentPage = 0
                    self?.performSearch(query)
                }
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
        
        currentSearchTask?.cancel()
        
        isLoading = true
        let searchQuery = query
        
        currentSearchTask = Task {
            do {
                let foods = try await fatSecretManager.fetchFoods(
                    query: searchQuery,
                    page: currentPage
                )
                
                guard !Task.isCancelled, self.query == searchQuery else {
                    return
                }
                
                await MainActor.run {
                    guard !Task.isCancelled, self.query == searchQuery else {
                        return
                    }
                    
                    self.foods = foods
                    self.appError = nil
                    self.isLoading = false
                }
            } catch {
                guard !Task.isCancelled, self.query == searchQuery else {
                    return
                }
                
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
        debouncedQuery = ""
    }
    
    // MARK: - Load Bookmarks Data
    func loadBookmarksSearchView(for mealType: MealType) async {
        guard firebaseAuth.currentUserExists() else { return }
        
        do {
            let favorites = try await firestore.loadBookmarksFirestore(
                for: mealType
            )
            let bookmarked = Set(favorites.map { $0.searchFoodId })
            
            let metadataDict = try await firestore.loadAllFoodMetadata(
                favorites,
                for: mealType
            )
            
            await MainActor.run {
                bookmarksByType[mealType] = favorites
                bookmarkedIdsByType[mealType] = bookmarked
                metadataByType[mealType] = metadataDict
                
                if selectedMealType == mealType {
                    displayBookmarks(for: mealType)
                }
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    func displayBookmarks(for mealType: MealType) {
        favoriteFoods = bookmarksByType[mealType] ?? []
        bookmarkedFoods = bookmarkedIdsByType[mealType] ?? []
        foodMetadataDict = metadataByType[mealType] ?? [:]
        
        let allHistory = historyByType[mealType] ?? []
        historyFoods = allHistory.filter { food in
            !bookmarkedFoods.contains(food.searchFoodId)
        }
        
        selectedMealType = mealType
        isLoading = false
        
        if query.isEmpty {
            foods = favoriteFoods
        }
    }
    
    func loadBookmarks() async {
        await withTaskGroup(of: Void.self) { group in
            for mealType in MealType.allCases {
                group.addTask {
                    await self.loadBookmarksSearchView(for: mealType)
                }
            }
        }
    }
    
    func resetQuery() {
        query = ""
    }
    
    // MARK: - Save Bookmarks
    func saveBookmarkOrder() async {
        await MainActor.run {
            if query.isEmpty {
                self.favoriteFoods = self.foods
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                favoriteFoods,
                for: selectedMealType
            )
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Remove Bookmarks
    func removeBookmarks(for ids: Set<Food.ID>) async {
        let originalFavoriteFoods = favoriteFoods
        let originalBookmarkedFoods = bookmarkedFoods
        let foodsToRemove = favoriteFoods.filter {
            ids.contains($0.searchFoodId)
        }
        
        await MainActor.run {
            withAnimation {
                favoriteFoods.removeAll { ids.contains($0.searchFoodId) }
                bookmarkedFoods.subtract(ids)
                
                var updatedMetadata = metadataByType[selectedMealType] ?? [:]
                for id in ids {
                    updatedMetadata.removeValue(forKey: id)
                }
                metadataByType[selectedMealType] = updatedMetadata
                
                bookmarksByType[selectedMealType] = favoriteFoods
                bookmarkedIdsByType[selectedMealType] = bookmarkedFoods
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                favoriteFoods,
                for: selectedMealType
            )
            for food in foodsToRemove {
                try await firestore.deleteFoodMetadata(
                    for: food.searchFoodId,
                    foodName: food.searchFoodName,
                    mealType: selectedMealType
                )
            }
        } catch {
            await MainActor.run {
                favoriteFoods = originalFavoriteFoods
                bookmarkedFoods = originalBookmarkedFoods
                bookmarksByType[selectedMealType] = originalFavoriteFoods
                bookmarkedIdsByType[selectedMealType] = originalBookmarkedFoods
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
                appError = .network
            }
        }
    }
    
    // MARK: - Toggle Bookmark
    func toggleBookmarkSearchView(for food: Food) async {
        let isAdding = !bookmarkedFoods.contains(food.searchFoodId)
        let mealType = selectedMealType
        
        let originalFavoriteFoods = favoriteFoods
        let originalBookmarkedFoods = bookmarkedFoods
        
        await MainActor.run {
            withAnimation {
                if isAdding {
                    favoriteFoods.append(food)
                    bookmarkedFoods.insert(food.searchFoodId)
                    
                    var history = historyByType[mealType] ?? []
                    history.removeAll { $0.searchFoodId == food.searchFoodId }
                    historyByType[mealType] = history
                    
                    if selectedMealType == mealType {
                        historyFoods = history
                    }
                } else {
                    favoriteFoods
                        .removeAll { $0.searchFoodId == food.searchFoodId }
                    bookmarkedFoods.remove(food.searchFoodId)
                    foodMetadataDict.removeValue(forKey: food.searchFoodId)
                    
                    var updatedMetadata = metadataByType[mealType] ?? [:]
                    updatedMetadata.removeValue(forKey: food.searchFoodId)
                    metadataByType[mealType] = updatedMetadata
                }
                
                bookmarksByType[mealType] = favoriteFoods
                bookmarkedIdsByType[mealType] = bookmarkedFoods
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                favoriteFoods,
                for: mealType
            )
            
            if !isAdding {
                try await firestore.deleteFoodMetadata(
                    for: food.searchFoodId,
                    foodName: food.searchFoodName,
                    mealType: mealType
                )
            }
        } catch {
            await MainActor.run {
                favoriteFoods = originalFavoriteFoods
                bookmarkedFoods = originalBookmarkedFoods
                bookmarksByType[mealType] = originalFavoriteFoods
                bookmarkedIdsByType[mealType] = originalBookmarkedFoods
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
                appError = .network
            }
        }
    }
    
    func updateMetadata(
        _ metadata: FoodMetadata,
        for mealType: MealType
    ) {
        foodMetadataDict[metadata.foodId] = metadata
        
        var updatedMetadata = metadataByType[mealType] ?? [:]
        updatedMetadata[metadata.foodId] = metadata
        metadataByType[mealType] = updatedMetadata
    }
    
    // MARK: - Bookmark Management
    func isBookmarkedSearchView(_ food: Food) -> Bool {
        return bookmarkedFoods.contains(food.searchFoodId)
    }
    
    func moveBookmarks(
        from indices: IndexSet,
        to newOffset: Int,
        in filteredBookmarks: [Food]
    ) {
        let itemsToMove = indices.map { filteredBookmarks[$0] }
        let idsToMove = Set(itemsToMove.map { $0.searchFoodId })
        
        var updatedFavorites = favoriteFoods
        updatedFavorites.removeAll { idsToMove.contains($0.searchFoodId) }
        
        let insertionIndex = newOffset < filteredBookmarks.count
        ? updatedFavorites
            .firstIndex(
                where: { $0.searchFoodId == filteredBookmarks[newOffset]
                        .searchFoodId
                }) ?? updatedFavorites.count
        : updatedFavorites.count
        
        updatedFavorites.insert(contentsOf: itemsToMove, at: insertionIndex)
        favoriteFoods = updatedFavorites
        
        if query.isEmpty {
            foods = updatedFavorites
        }
        
        Task {
            await saveBookmarkOrder()
        }
    }
    
    // MARK: - Add to History
    func addToHistory(_ food: Food, for mealType: MealType) async {
        let isBookmarked = bookmarkedFoods.contains(food.searchFoodId)
        
        if isBookmarked {
            return
        }
        
        var history = historyByType[mealType] ?? []
        
        history.removeAll { $0.searchFoodId == food.searchFoodId }
        history.insert(food, at: 0)
        
        if history.count > maxHistoryCount {
            history = Array(history.prefix(maxHistoryCount))
        }
        
        historyByType[mealType] = history
        
        if selectedMealType == mealType {
            let historyCopy = history
            
            await MainActor.run {
                historyFoods = historyCopy
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
    
    // MARK: - UI Helper
    func triggerFoodAlert() {
        Task { @MainActor in
            guard !isAlertInProgress else {
                try? await Task.sleep(for: .seconds(0.3))
                triggerFoodAlert()
                return
            }
            
            isAlertInProgress = true
            
            try? await Task.sleep(for: .seconds(0.25))
            
            isFoodAddedAlertVisible = true
            
            try? await Task.sleep(for: .seconds(1.5))
            isFoodAddedAlertVisible = false
            
            try? await Task.sleep(for: .seconds(0.3))
            isAlertInProgress = false
        }
    }
    
    var contentState: SearchContentState {
        if isLoading {
            .loading
        } else if let error = appError {
            .error(error)
        } else if foods.isEmpty && historyFoods.isEmpty {
            .empty
        } else {
            .results
        }
    }
    
    var showPagination: Bool {
        return !query.isEmpty && contentState == .results
    }
    
    var selectionStatusText: String {
        selectedItems.isEmpty
        ? "Select bookmarks"
        : selectedItems.count == 1
        ? "1 Bookmark Selected"
        : "\(selectedItems.count) Bookmarks Selected"
    }
    
    var removeDialogMessage: String {
        selectedItems.count == 1
        ? "The selected bookmark will be removed from favorites."
        : "The selected bookmarks will be removed from favorites."
    }
    
    var removeDialogTitle: String {
        let count = selectedItems.count
        
        return count == 1
        ? "Remove bookmark"
        : "Remove \(count) bookmarks"
    }
    
    var canEditMealType: Bool {
        return !isLoading && !foods.isEmpty
    }
    
    var isEditModeActive: Bool {
        editingState == .active
    }
    
    enum EditingState {
        case inactive
        case active
    }
    
    enum SearchContentState: Equatable {
        case loading
        case error(AppError)
        case empty
        case results
    }
}

extension SearchViewModel: SearchViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
