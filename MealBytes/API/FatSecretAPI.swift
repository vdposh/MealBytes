//
//  FatSecretAPI.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Moya

enum FatSecretAPI {
    case searchFoods(query: String)
    case getFoodDetails(foodID: String)
}

extension FatSecretAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://platform.fatsecret.com/rest")!
    }
    
    var path: String {
        switch self {
        case .searchFoods:
            "/foods/search/v1"
        case .getFoodDetails:
            "/food/v4"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        let parameters: [String: Any]
        
        switch self {
        case .searchFoods(let query):
            parameters = [
                "format": format,
                "search_expression": query
            ]
            
        case .getFoodDetails(let foodID):
            parameters = [
                "format": format,
                "food_id": foodID
            ]
        }
        
        return .requestParameters(parameters: parameters,
                                  encoding: URLEncoding.queryString)
    }
    
    var headers: [String: String]? {
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE2MDM2NDEsImV4cCI6MTc0MTY5MDA0MSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.c0TJ4hBzbq1L9Gfs_N5zKMivea4DRuBteLEPp1wO_VoVk3a66xB8p6_SaRE3kK2ZlpYait6esmO9u9jJFQp7v3kqobs-P_KT5D8Z_hZ15TDxd9hed8-_kWu1tw9W4QpYH378__thuojS7bBruCBiTdw-z5duet1jQTcKCyqpRrzlQGOCUmu7VTp4wtDi6hHNaxu_2cYZb_35SOnyQDfPBzUa1Vbm_oVDsykrw7c9LOIl6pA5Y222V-YcZfYavbpeKpwaalxK8e0JW6xc5GsCfhhwfjGN9EOVLxuwowUN2KwW1rek-FOk2L9NEVzv5yQs1mHlzzU3Ooh3KyYb47BmwV3WLoW3iWmZrZvKg8zCo4hpl4v_0YrfA-RADf0vp9QPlc5x9AYDQT8kaHNL6ErD4EaY20iABOR8qdpT0FknyXgOkPc4c3qGUxpD_67MSws6Tu648j6Oi5wxk-FDunzV8NsBWTVIji_g5jtr5geR104tP6bFHV-GPZPpierIuMQ3I7F1mt0NxQyKsc-Sm2CPkKmqvH4q9Es-1anjJo8-inZavZ9Atd6TR715eWqwTXLTQJ4lf4P-dPqXqyDciajhH65lBTpbW8J8bkqmxcqJPOP4D_eHUZxKmAWezBbRAftj7baWKu1JtTbeeaaK_QyUZQzbCaAu3g-9O1ZQYEgE6Bg"]
    }
    
    var format: String {
        "json"
    }
}
