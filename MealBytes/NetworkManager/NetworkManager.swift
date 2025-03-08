//
//  NetworkManager.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Moya

protocol NetworkManagerProtocol {
    func searchFoods(query: String) async throws -> [Food]
    func getFoodDetails(foodID: String) async throws -> FoodDetail
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
                        continuation.resume(throwing:
                                                AppErrorType.decodingError)
                    }
                case .failure:
                    continuation.resume(throwing:
                                            AppErrorType.networkError)
                }
            }
        }
    }
    
    func searchFoods(query: String) async throws -> [Food] {
        let response: FoodResponse = try await performRequest(
            .searchFoods(query: query),
            responseType: FoodResponse.self
        )
        return response.foods
    }
    
    func getFoodDetails(foodID: String) async throws -> FoodDetail {
        let response: FoodDetailResponse = try await performRequest(
            .getFoodDetails(foodID: foodID),
            responseType: FoodDetailResponse.self
        )
        return response.food
    }
}
