//
//  FatSecretManager.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Moya

protocol FatSecretManagerProtocol {
    func fetchFoods(query: String, page: Int) async throws -> [Food]
    func fetchFoodDetails(foodId: Int) async throws -> FoodDetail
}

final class FatSecretManager: FatSecretManagerProtocol {
    private lazy var provider = MoyaProvider<FatSecretAPI>()
    
    private func performRequest<T: Decodable>(
        _ target: FatSecretAPI,
        responseType: T.Type
    ) async throws -> T {
        try await ensureValidToken()
        
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(
                            T.self,
                            from: response.data
                        )
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        switch target {
                        case .searchFoods:
                            continuation.resume(throwing: AppError.decoding)
                        case .getFoodDetails:
                            continuation.resume(throwing: AppError.decoding)
                        }
                    }
                case .failure:
                    continuation.resume(throwing: AppError.networkRefresh)
                }
            }
        }
    }
    
    private func ensureValidToken() async throws {
        if TokenManager.shared.accessToken == nil {
            try await TokenManager.shared.fetchToken()
        }
    }
    
    func fetchFoods(query: String, page: Int) async throws -> [Food] {
        let response: FoodResponse = try await performRequest(
            .searchFoods(query: query, page: page),
            responseType: FoodResponse.self
        )
        
        guard !response.foods.isEmpty else {
            throw AppError.results
        }
        
        return response.foods
    }
    
    func fetchFoodDetails(foodId: Int) async throws -> FoodDetail {
        let response: FoodDetailResponse = try await performRequest(
            .getFoodDetails(foodID: foodId),
            responseType: FoodDetailResponse.self
        )
        
        return response.food
    }
}
