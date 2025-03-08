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
    @Published var query: String = "" {
        didSet {
            debounceSearch(query)
        }
    }
    @Published var errorMessage: AppError?
    
    private let networkManager: NetworkManagerProtocol
    private var searchCancellable: AnyCancellable?
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    private func debounceSearch(_ query: String) {
        searchCancellable?.cancel()
        searchCancellable = $query
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task { @MainActor in
                    await self?.performSearch(query)
                }
            }
    }
    
    @MainActor
    private func performSearch(_ query: String) async {
        if query.isEmpty {
            foods = []
            errorMessage = nil
            return
        }
        do {
            self.foods = try await networkManager.searchFoods(query: query)
            self.errorMessage = nil
        } catch {
            self.errorMessage = (error as? AppError) ?? .networkError
        }
    }
}

#Preview {
    SearchView()
}
