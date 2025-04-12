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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQ0NjE1MjYsImV4cCI6MTc0NDU0NzkyNiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.d8UCMDHMIIcBf8iH8hfpcC6eArV08ZUPK9FEw94TEdhrapp8Ff84Twod2ldOD-n2a6fw0yldDNXrUxtJMpUjMfry4IffSgtzQp0TFo8kM0uSp83PfAbKfOziG0ZULEZbFlgDupaskqK4a3nDktoKRKf1662N297nxRRrRmbN1PK3yLTUWvS8IDbJUY80nFE4QVEC6Hrd9meilk9dYOnXEfK2_7_KFH1L8LUVO7Rv1bysjarQk5OvRch8xD0WBcp21D4fMEj7Vn6_f36tXbZbkvlen0roj4Z-Tyc0MF86D8f6oLHpil41rQvDqZtzhWnSb5losIWU1eOFfxPlN72ucT-mJjt8hJDA9_6Bvf3ve14goYzzdBJaWIjG0Cv8LePP5KPiK4ntKA6vmDZTOu0Y62Jj2Uyfobsy0fv6FTmWPIOACqos7oyu3qK-vLzieWb7EAvMSHp60kDwiZWHz-vLzyhdiGtyRQ19_vE5GLfhPR0_jvIQctjARnmLqyD-vx2hGDuZ8C_s8L40gyLUzqt_sMm8d5VgQqt6qTrpl-Vm1NGw9N-kW-v8k1FfC7ZqIq51rTkV2o7zaMPOtn3m6TzII81YDQvG0r2D_Qc_fK1KlCkFDZAXdbYsSQPKA8Rm7t4hMEPVjE5MHjjWzidiXfJHDenLytLWEJCbOJA9s9p1iPE"]
    }
    
    var format: String {
        "json"
    }
}
