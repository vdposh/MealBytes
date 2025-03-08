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
    @Published var query: String = ""
    @Published var errorMessage: AppError?
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func searchFoods(_ query: String) {
        if query.isEmpty {
            foods = []
            return
        }
        
        Task {
            do {
                self.foods = try await networkManager.searchFoods(query: query)
                self.errorMessage = nil
            } catch {
                self.errorMessage = (error as? AppError) ?? .networkError
            }
        }
    }
}

#Preview {
    SearchView()
}
