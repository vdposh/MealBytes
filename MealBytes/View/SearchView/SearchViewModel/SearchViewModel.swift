//
//  SearchViewModel.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

//@MainActor
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
                let result = try await networkManager.searchFoods(query: query)
                self.foods = result
                self.errorMessage = nil
            } catch {
                self.errorMessage = AppError(
                    title: "Unknown Error",
                    message: error.localizedDescription
                )
            }
        }
    }
}

#Preview {
    SearchView()
}
