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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDM2OTg2NzIsImV4cCI6MTc0Mzc4NTA3MiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.BUeaHEYNhAZSe6xdEe8QsDBuTlXL5hbENtPgujFnJjAyrsb0aprysQRr0_vEUHCewtRb_dOZ-YyP7XjfM5cxJnbFDeQBrfAFqhJnUrzAEJlZ2fgmsjJ42_ditTVhyq5Lfin2S7E54cQnYP4V63x4f2EK67kpyxv6zlKal9YJbxJooi-nsba8IZrXmOYYsyVmFUA3J9qg2hyy6aG3iLNrHKc5bMuJXrQpcFVVGmMF9KqrVdnCDpLx_JB8D90qacKQIxfIMtxA_M2XwxrUCUr5Y2Z0QhEy8E2FRpG_28XWllpjsgMpBfmCIFmfx2ohqh5GHGPcfsAGIAF7i_I6OIE6KqqV3zvvr7AChyFvXadWqcRvYUyvYGqGYnbsats1cnpe5iqzGK8xkHjqU7EEavfcEIGZdscOmlpJpBoRAArHttYU7RdfR26dNBaOFmyQ4_DqXni9MQkuUaPcxVeNv-00kN1CHAXqQlmuE2b-gagD2oJYcnYR-4vgwwQHo-k2-y580wiIjIZElcALNPCEfm84QarRB7v3lc2HDMRH5V6lTipGezsn6URHsFWIwLsctgTPlExRSHGLYJrNjzNmNWpgUidVGktDJVyMyidg8wmdGXqJqcE6aVRBxyZ_6illDId4ymwhy05aof9GkE5rcNFQg7elQ2fGX2ZWpGs7WC6-sxI"]
    }
    
    var format: String {
        "json"
    }
}
