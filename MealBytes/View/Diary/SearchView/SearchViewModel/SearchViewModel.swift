//
//  SearchViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Combine
import OSLog

protocol SearchViewModelProtocol {
    var foodMetadataDict: [Int: FoodMetadata] { get set }
    
    func toggleBookmarkSearchView(for food: Food, animated: Bool) async
    func loadBookmarksSearchView(for mealType: MealType) async
    func loadSearchViewData() async
    func updateMetadata(
        _ metadata: FoodMetadata,
        for mealType: MealType
    )
    func displaySearchViewData(for mealType: MealType)
    func addToHistory(_ food: Food, for mealType: MealType) async
    func isBookmarkedSearchView(_ food: Food) -> Bool
    func isBookmarked(_ food: Food, for mealType: MealType) -> Bool
    func triggerFoodAlert()
    func resetSearchView()
}

final class SearchViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var favoriteFoods: [Food] = []
    @Published var historyFoods: [Food] = []
    @Published var bookmarkedFoods: Set<Int> = []
    @Published var foodMetadataDict: [Int: FoodMetadata] = [:]
    @Published var selectedItems = Set<Food.ID>()
    @Published var appError: AppError?
    @Published var selectedFood: Food?
    @Published var selectedMealType: MealType = .breakfast
    @Published var selectedSegment: ListSegment = .bookmarks
    @Published var debouncedQuery: String = ""
    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            }
        }
    }
    @Published var isLoading: Bool = false
    @Published var showMealType: Bool = false
    @Published var showRemoveBookmarksDialog: Bool = false
    @Published var showRemoveHistoryDialog = false
    @Published var isEditingActive = false
    @Published var isMoving = false
    @Published var isFoodAddedAlertVisible: Bool = false
    @Published var isAlertInProgress: Bool = false
    
    private var bookmarksByType: [MealType: [Food]] = [:]
    private var bookmarkedIdsByType: [MealType: Set<Int>] = [:]
    private var metadataByType: [MealType: [Int: FoodMetadata]] = [:]
    
    private var historyByType: [MealType: [Food]] = [:]
    private let maxHistoryCount = 12
    
    private var maxResultsPerPage: Int = 20
    private var currentPage: Int = 0
    
    private let fatSecretManager: FatSecretManagerProtocol = FatSecretManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    
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
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self else { return }
                
                if query.isEmpty {
                    self.debouncedQuery = ""
                    return
                }
                
                if self.debouncedQuery.isEmpty {
                    self.debouncedQuery = query
                    self.currentPage = 0
                    self.performSearch(query)
                }
            }
            .store(in: &cancellables)
        
        $query
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self, !query.isEmpty,
                      self.debouncedQuery != query else { return }
                self.debouncedQuery = query
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
    
    // MARK: - Load SearchView Data
    func loadSearchViewData() async {
        async let segmentTask: () = loadSelectedSegment()
        
        await withTaskGroup(of: Void.self) { group in
            await loadMetadataSearchView()
            
            for mealType in MealType.allCases {
                group.addTask {
                    await self.loadBookmarksSearchView(for: mealType)
                    await self.loadHistorySearchView(for: mealType)
                }
            }
        }
        
        await segmentTask
    }
    
    // MARK: - Load Bookmarks Data
    func loadBookmarksSearchView(for mealType: MealType) async {
        guard firebaseAuth.currentUserExists() else { return }
        
        do {
            let favorites = try await firestore.loadBookmarksFirestore(
                for: mealType
            )
            let bookmarked = Set(favorites.map { $0.searchFoodId })
            
            await MainActor.run {
                bookmarksByType[mealType] = favorites
                bookmarkedIdsByType[mealType] = bookmarked
                
                if selectedMealType == mealType {
                    displaySearchViewData(for: mealType)
                }
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    // MARK: - Load History Data
    func loadHistorySearchView(for mealType: MealType) async {
        guard firebaseAuth.currentUserExists() else { return }
        
        do {
            let history = try await firestore.loadHistoryFirestore(
                for: mealType
            )
            
            await MainActor.run {
                historyByType[mealType] = history
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    // MARK: - Load Selected Segment
    private func loadSelectedSegment() async {
        do {
            let raw = try await firestore.loadSelectedSegmentFirestore()
            await MainActor.run {
                selectedSegment = ListSegment(rawValue: raw) ?? .bookmarks
            }
        } catch {
            Logger.search
                .error(
                    "loadSelectedSegment failed: \(error.localizedDescription)"
                )
        }
    }
    
    // MARK: - Load Metadata
    func loadMetadataSearchView() async {
        guard firebaseAuth.currentUserExists() else { return }
        
        do {
            for mealType in MealType.allCases {
                let metadataDict = try await firestore.loadFoodMetadata(
                    for: mealType
                )
                await MainActor.run {
                    var updatedMetadata = metadataByType[mealType] ?? [:]
                    for (key, value) in metadataDict {
                        updatedMetadata[key] = value
                    }
                    metadataByType[mealType] = updatedMetadata
                }
            }
            
            await MainActor.run {
                foodMetadataDict = metadataByType[selectedMealType] ?? [:]
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    func resetSearchView() {
        query = ""
        selectedItems.removeAll()
        selectedFood = nil
        isEditingActive = false
    }
    
    // MARK: - Display SearchView Data
    func displaySearchViewData(for mealType: MealType) {
        Task { @MainActor in
            favoriteFoods = bookmarksByType[mealType] ?? []
            bookmarkedFoods = bookmarkedIdsByType[mealType] ?? []
            foodMetadataDict = metadataByType[mealType] ?? [:]
            
            let allHistory = historyByType[mealType] ?? []
            historyFoods = allHistory
                .filter { !bookmarkedFoods.contains($0.searchFoodId) }
            
            selectedMealType = mealType
            
            isLoading = false
            
            if query.isEmpty {
                foods = favoriteFoods
            }
        }
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
            Logger.search
                .error(
                    "saveBookmarkOrder failed: \(error.localizedDescription)"
                )
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
                bookmarksByType[selectedMealType] = favoriteFoods
                bookmarkedIdsByType[selectedMealType] = bookmarkedFoods
                
                let allHistory = historyByType[selectedMealType] ?? []
                historyFoods = allHistory.filter {
                    !bookmarkedFoods.contains($0.searchFoodId)
                }
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
            }
        }
        
        await MainActor.run {
            for food in foodsToRemove {
                deleteMetadataIfNotInHistory(
                    for: food,
                    mealType: selectedMealType
                )
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                favoriteFoods,
                for: selectedMealType
            )
        } catch {
            Logger.search
                .error("removeBookmarks failed: \(error.localizedDescription)")
            
            await MainActor.run {
                favoriteFoods = originalFavoriteFoods
                bookmarkedFoods = originalBookmarkedFoods
                bookmarksByType[selectedMealType] = originalFavoriteFoods
                bookmarkedIdsByType[selectedMealType] = originalBookmarkedFoods
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
            }
        }
    }
    
    func removeSelectedBookmarks(ids: Set<Food.ID>) async {
        let filtered = favoriteFoods
            .filter { ids.contains($0.searchFoodId) }
            .map { $0.searchFoodId }
        
        await removeBookmarks(for: Set(filtered))
    }
    
    // MARK: - Toggle Bookmark
    func toggleBookmarkSearchView(
        for food: Food,
        animated: Bool = true
    ) async {
        let isAdding = !bookmarkedFoods.contains(food.searchFoodId)
        let mealType = selectedMealType
        
        let originalFavoriteFoods = favoriteFoods
        let originalBookmarkedFoods = bookmarkedFoods
        
        let update = {
            if isAdding {
                self.favoriteFoods.append(food)
                self.bookmarkedFoods.insert(food.searchFoodId)
            } else {
                self.favoriteFoods
                    .removeAll { $0.searchFoodId == food.searchFoodId }
                self.bookmarkedFoods.remove(food.searchFoodId)
                self.deleteMetadataIfNotInHistory(
                    for: food,
                    mealType: mealType
                )
            }
            
            self.bookmarksByType[mealType] = self.favoriteFoods
            self.bookmarkedIdsByType[mealType] = self.bookmarkedFoods
            
            let allHistory = self.historyByType[mealType] ?? []
            self.historyFoods = allHistory
                .filter { !self.bookmarkedFoods.contains($0.searchFoodId) }
            
            if self.query.isEmpty {
                self.foods = self.favoriteFoods
            }
        }
        
        await MainActor.run {
            if animated {
                withAnimation {
                    update()
                }
            } else {
                update()
            }
        }
        
        do {
            try await firestore
                .addBookmarkFirestore(favoriteFoods, for: mealType)
        } catch {
            Logger.search
                .error("toggleBookmark failed: \(error.localizedDescription)")
            await MainActor.run {
                favoriteFoods = originalFavoriteFoods
                bookmarkedFoods = originalBookmarkedFoods
                bookmarksByType[mealType] = originalFavoriteFoods
                bookmarkedIdsByType[mealType] = originalBookmarkedFoods
                
                if query.isEmpty {
                    foods = favoriteFoods
                }
            }
        }
    }
    
    // MARK: - Delete Metadata If Not In History
    private func deleteMetadataIfNotInHistory(
        for food: Food,
        mealType: MealType
    ) {
        let history = historyByType[mealType] ?? []
        let isInHistory = history.contains {
            $0.searchFoodId == food.searchFoodId
        }
        
        if !isInHistory {
            foodMetadataDict.removeValue(forKey: food.searchFoodId)
            metadataByType[mealType]?.removeValue(forKey: food.searchFoodId)
            
            Task {
                do {
                    try await firestore.deleteFoodMetadata(
                        for: food.searchFoodId,
                        foodName: food.searchFoodName,
                        mealType: mealType
                    )
                } catch {
                    Logger.search
                        .error(
                            "deleteFoodMetadata failed: \(error.localizedDescription)"
                        )
                }
            }
        }
    }
    
    // MARK: - Update Metadata
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
        isMoving = true
        
        if query.isEmpty {
            foods = updatedFavorites
        }
        
        Task {
            await saveBookmarkOrder()
            
            try? await Task.sleep(for: .seconds(0.5))
            
            await MainActor.run {
                isMoving = false
            }
        }
    }
    
    func isBookmarked(_ food: Food, for mealType: MealType) -> Bool {
        let bookmarked = bookmarkedIdsByType[mealType] ?? []
        return bookmarked.contains(food.searchFoodId)
    }
    
    // MARK: - Transfer Bookmarks
    func transferBookmarks(for foods: [Food], to mealType: MealType) async {
        let fromMealType = selectedMealType
        guard fromMealType != mealType else { return }
        
        let fromIds = Set(foods.map { $0.searchFoodId })
        let fromExisting = bookmarksByType[fromMealType] ?? []
        let fromUpdated = fromExisting.filter {
            !fromIds.contains($0.searchFoodId)
        }
        
        let toExisting = bookmarksByType[mealType] ?? []
        let toExistingIds = Set(toExisting.map { $0.searchFoodId })
        let toUpdated = toExisting + foods.filter {
            !toExistingIds.contains($0.searchFoodId)
        }
        
        await MainActor.run {
            withAnimation {
                bookmarksByType[fromMealType] = fromUpdated
                bookmarkedIdsByType[fromMealType] = Set(
                    fromUpdated.map { $0.searchFoodId
                    })
                
                bookmarksByType[mealType] = toUpdated
                bookmarkedIdsByType[mealType] = Set(
                    toUpdated.map { $0.searchFoodId
                    })
                
                if selectedMealType == fromMealType {
                    favoriteFoods = fromUpdated
                    bookmarkedFoods = bookmarkedIdsByType[fromMealType] ?? []
                    
                    let allHistory = historyByType[fromMealType] ?? []
                    historyFoods = allHistory.filter {
                        !bookmarkedFoods.contains($0.searchFoodId)
                    }
                }
            }
        }
        
        do {
            try await firestore
                .addBookmarkFirestore(fromUpdated, for: fromMealType)
            try await firestore.addBookmarkFirestore(toUpdated, for: mealType)
            
            for food in foods {
                if let metadata = foodMetadataDict[food.searchFoodId] {
                    try await firestore
                        .saveFoodMetadata(metadata, for: mealType)
                    
                    await MainActor.run {
                        var updated = metadataByType[mealType] ?? [:]
                        updated[food.searchFoodId] = metadata
                        metadataByType[mealType] = updated
                    }
                }
            }
        } catch {
            Logger.search
                .error("moveBookmarks failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Add to History
    func addToHistory(_ food: Food, for mealType: MealType) async {
        var history = historyByType[mealType] ?? []
        
        history.removeAll { $0.searchFoodId == food.searchFoodId }
        history.insert(food, at: 0)
        
        var removedFoods: [Food] = []
        while history.count > maxHistoryCount {
            if let removed = history.popLast() {
                removedFoods.append(removed)
            }
        }
        
        historyByType[mealType] = history
        
        let removedFoodsCopy = removedFoods
        let historyCopy = history
        
        await MainActor.run {
            for removedFood in removedFoodsCopy {
                if !bookmarkedFoods.contains(removedFood.searchFoodId) {
                    deleteMetadataIfNotInHistory(
                        for: removedFood,
                        mealType: mealType
                    )
                }
            }
            
            if selectedMealType == mealType {
                historyFoods = historyCopy
                    .filter { !bookmarkedFoods.contains($0.searchFoodId) }
            }
            displaySearchViewData(for: mealType)
        }
        
        Task {
            do {
                try await firestore.addHistoryFirestore(history, for: mealType)
            } catch {
                Logger.search
                    .error(
                        "addHistoryFirestore failed: \(error.localizedDescription)"
                    )
            }
        }
    }
    
    // MARK: - Delete History Item
    func deleteHistoryItem(for ids: Set<Food.ID>) async {
        let mealType = selectedMealType
        let original = historyByType[mealType] ?? []
        
        let visibleIds = ids.filter { id in
            historyFoods.contains { $0.searchFoodId == id }
        }
        
        let updated = original.filter { !visibleIds.contains($0.searchFoodId) }
        
        await MainActor.run {
            withAnimation {
                historyByType[mealType] = updated
                if selectedMealType == mealType {
                    historyFoods = updated.filter {
                        !bookmarkedFoods.contains($0.searchFoodId)
                    }
                }
            }
        }
        
        await deleteMetadataIfOrphaned(
            for: Set(visibleIds),
            mealType: mealType
        )
        
        do {
            try await firestore.addHistoryFirestore(updated, for: mealType)
        } catch {
            Logger.search
                .error("removeHistory failed: \(error.localizedDescription)")
            await MainActor.run {
                historyByType[mealType] = original
                historyFoods = original.filter {
                    !bookmarkedFoods.contains($0.searchFoodId)
                }
            }
        }
    }
    
    private func deleteMetadataIfOrphaned(
        for ids: Set<Food.ID>,
        mealType: MealType
    ) async {
        let orphanedIds = await MainActor.run { () -> [Int] in
            var result: [Int] = []
            
            for id in ids {
                let inHistory = (historyByType[mealType] ?? []).contains {
                    $0.searchFoodId == id
                }
                let inBookmarks = bookmarkedIdsByType[mealType]?.contains(
                    id
                ) ?? false
                
                guard !inHistory && !inBookmarks else { continue }
                
                foodMetadataDict.removeValue(forKey: id)
                metadataByType[mealType]?.removeValue(forKey: id)
                result.append(id)
            }
            
            return result
        }
        
        guard !orphanedIds.isEmpty else { return }
        
        do {
            try await firestore.deleteFoodMetadataBatch(
                for: orphanedIds,
                mealType: mealType
            )
        } catch {
            Logger.search.error(
                "deleteFoodMetadataBatch failed: \(error.localizedDescription)"
            )
        }
    }
    
    // MARK: - Select Segment
    func selectSegment(_ segment: ListSegment) {
        guard selectedSegment != segment else { return }
        
        withAnimation {
            selectedSegment = segment
        }
        
        Task {
            do {
                try await firestore
                    .saveSelectedSegmentFirestore(segment.rawValue)
            } catch {
                Logger.search
                    .error(
                        "saveSelectedSegment failed: \(error.localizedDescription)"
                    )
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
    
    // MARK: - State
    var contentState: SearchContentState {
        if isLoading {
            return .loading
        }
        if let error = appError {
            return .error(error)
        }
        
        if !debouncedQuery.isEmpty {
            return foods.isEmpty ? .error(.results) : .results
        }
        
        if favoriteFoods.isEmpty && historyFoods.isEmpty {
            return .emptyEntries
        }
        
        switch selectedSegment {
        case .bookmarks:
            return favoriteFoods.isEmpty ? .emptyBookmarks : .results
        case .recent:
            return historyFoods.isEmpty ? .emptyRecent : .results
        }
    }
    
    // MARK: - Error
    enum SearchContentState: Equatable {
        case loading
        case error(AppError)
        case emptyEntries
        case emptyBookmarks
        case emptyRecent
        case results
    }
    
    // MARK: - Alert
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
    
    // MARK: - UI Helper
    var energyUnit: EnergyUnit {
        mainViewModel.energyUnit
    }
    
    var showPagination: Bool {
        return !query.isEmpty && contentState == .results
    }
    
    var navigationSubtitleText: String {
        isEditingActive ? selectionStatusText : ""
    }
    
    var selectedBookmarksCount: Int {
        favoriteFoods.filter { selectedItems.contains($0.searchFoodId) }.count
    }

    var selectedHistoryCount: Int {
        historyFoods.filter { selectedItems.contains($0.searchFoodId) }.count
    }
    
    var selectionStatusText: String {
        let count = selectedSegment == .bookmarks
        ? selectedBookmarksCount
        : selectedHistoryCount
        
        guard count > 0 else { return "Select" }
        
        return count == 1
        ? "1 \(selectedSegment == .bookmarks ? "Bookmark" : "Recent Log")"
        : "\(count) \(selectedSegment == .bookmarks ? "Bookmarks" : "Recent Logs")"
    }

    var removeDialogMessage: String {
        "The selected \(selectedBookmarksCount == 1 ? "bookmark" : "bookmarks") will be removed."
    }
    
    var removeDialogTitle: String {
        "Remove \(selectedBookmarksCount) \(selectedBookmarksCount == 1 ? "bookmark" : "bookmarks")"
    }
    
    var deleteHistoryDialogMessage: String {
        "The selected \(selectedHistoryCount == 1 ? "recent log" : "recent logs") will be deleted."
    }
    
    var deleteHistoryDialogTitle: String {
        "Delete \(selectedHistoryCount) recent \(selectedHistoryCount == 1 ? "log" : "logs")"
    }
}

enum ListSegment: String, CaseIterable {
    case bookmarks = "Bookmarks"
    case recent = "Recent Logs"
}

extension SearchViewModel: SearchViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
