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
            .handleEvents(receiveOutput: { [weak self] query in
                if query.isEmpty {
                    self?.foods = []
                    self?.errorMessage = nil
                }
            })
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                Task {
                    guard let self else { return }
                    do {
                        let foods = try await self.networkManager
                            .fetchFoods(query: query)
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
}

#Preview {
    SearchView()
}
