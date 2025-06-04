//
//  NetworkManager.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Moya

protocol NetworkManagerProtocol {
    func fetchFoods(query: String, page: Int) async throws -> [Food]
    func fetchFoodDetails(foodId: Int) async throws -> FoodDetail
}

final class NetworkManager: NetworkManagerProtocol {
    
    private lazy var provider = MoyaProvider<FatSecretAPI>()
    
    private func performRequest<T: Decodable>(
        _ target: FatSecretAPI,
        responseType: T.Type
    ) async throws -> T {
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
                            continuation.resume(throwing: AppError.results)
                        case .getFoodDetails:
                            continuation.resume(throwing: AppError.decoding)
                        }
                    }
                case .failure:
                    continuation.resume(throwing: AppError.network)
                }
            }
        }
    }
    
    func fetchFoods(query: String, page: Int) async throws -> [Food] {
        let response: FoodResponse = try await performRequest(
            .searchFoods(query: query, page: page),
            responseType: FoodResponse.self
        )
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
