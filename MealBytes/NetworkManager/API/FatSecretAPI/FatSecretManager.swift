//
//  FatSecretManager.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import Foundation

protocol FatSecretManagerProtocol {
    func fetchFoods(query: String, page: Int) async throws -> [Food]
    func fetchFoodDetails(foodId: Int) async throws -> FoodDetail
}

final class FatSecretManager: FatSecretManagerProtocol {
    private let baseURL = "https://platform.fatsecret.com/rest"
    private let session: URLSession = .shared
    
    private enum Endpoint {
        case searchFoods(query: String, page: Int)
        case foodDetails(foodId: Int)
        
        var path: String {
            switch self {
            case .searchFoods: "/foods/search/v1"
            case .foodDetails: "/food/v5"
            }
        }
        
        var parameters: [String: String] {
            var params = ["format": "json"]
            
            switch self {
            case .searchFoods(let query, let page):
                params["search_expression"] = query
                params["page_number"] = String(page)
                
            case .foodDetails(let foodId):
                params["food_id"] = String(foodId)
            }
            
            return params
        }
    }
    
    private func performRequest<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        try await ensureValidToken()
        
        var components = URLComponents(
            string: baseURL + endpoint.path
        )
        components?.queryItems = endpoint.parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = components?.url else {
            throw AppError.networkRefresh
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(
            "Bearer \(TokenManager.shared.accessToken ?? "")",
            forHTTPHeaderField: "Authorization"
        )
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AppError.networkRefresh
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw AppError.decoding
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
            .foodDetails(foodId: foodId),
            responseType: FoodDetailResponse.self
        )
        
        return response.food
    }
}
