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
            currentPage = 0
            debounceSearch(query)
        }
    }
    @Published var errorMessage: AppError?
    @Published var currentPage: Int = 0
    @Published var maxResultsPerPage: Int = 20

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

                Task {
                    do {
                        let foods = try await self.networkManager
                            .fetchFoods(query: query,
                                        page: self.currentPage,
                                        maxResults: self.maxResultsPerPage)
                        await MainActor.run {
                            self.foods = foods
                            self.errorMessage = nil
                        }
                    } catch {
                        await MainActor.run {
                            switch error {
                            case let appError as AppError:
                                self.errorMessage = appError
                            default:
                                self.errorMessage = .networkError
                            }
                        }
                    }
                }
            }
    }

    // MARK: - Pagination
    func loadNextPage() {
        currentPage += 1
        debounceSearch(query)
    }

    func loadPreviousPage() {
        if currentPage > 0 {
            currentPage -= 1
            debounceSearch(query)
        }
    }
}

#Preview {
    SearchView()
}
