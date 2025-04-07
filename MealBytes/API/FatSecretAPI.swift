//
//  FatSecretAPI.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Moya

enum FatSecretAPI {
    case searchFoods(query: String, page: Int)
    case getFoodDetails(foodID: Int)
}

extension FatSecretAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://platform.fatsecret.com/rest")!
    }
    
    var path: String {
        switch self {
        case .searchFoods: "/foods/search/v1"
        case .getFoodDetails: "/food/v4"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        let parameters: [String: Any]
        
        switch self {
        case .searchFoods(let query, let page):
            parameters = [
                "format": format,
                "search_expression": query,
                "page_number": page
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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQwMDkwMzAsImV4cCI6MTc0NDA5NTQzMCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.AD9wXohjGNsBEUIr_uwPqfpqhyjgxYwTG0XvKhF5zrAjF1wQAMFjnDbpwT2bS0XuWUDKDeH_1g5elncWt3WiLQEBJZEm3HSleJ5m2K-YAVU_y5zXUSQaXGB-s3fDf5Geprvm4qYzTeYTWhmCfv88LrzUy8I70i9h_RJrXiC9bon4E_SphR9s0YxdnkY3K_7wo2G69JY_AFAplcBm6BhcHtOVxQPJ4pwhQ4Dq4nTEOvHtAWxBAuODisqIN570qG2S3Aji-NFDex7Y3gABGZNzt6W6xDbOdPFJl9rCYY0LMtaoBm4fyzxMQWRCoyZyocIWuc36Cj0hxA90DTxtI2aifuodemcvzLvrPii3DQQs0bLIaMmrHuazICPSkD9arH3r9hAZ6p2n9vFYLH_7XnLblJ1HrUmlqo0hcfd6cKJX-rhV4z8ffaQMTXqgJxVVPahnGxi9ZVbTXSjjsgQPFNy7rDpsV36IdfiNb5PyjQ1qvP8VHuieFZ14wcuwTWGWVaDGA7RrvZkG3RMawJROLxfffTG0XO_8IceDicp5Ttmv-L_mEZpTaNAAn8pmLV6tpskS2vYLf4Irr6Rcj6DwcgA1XWkDOd_bNz3Dhv5kN9m56z9sFfk2vh57eHVjZZIMKBlrkL0hjsoReiwnWmjH__kLPystWti2TeyVAliVQGwPmOQ"]
    }
    
    var format: String {
        "json"
    }
}
