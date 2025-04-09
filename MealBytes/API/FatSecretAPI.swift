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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQyMDk1NDksImV4cCI6MTc0NDI5NTk0OSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.j2MQp_fiCKgsNj1Xf51oYzi2gUecuoPkk6pa6PzzYYHpJdip3_xHl6lvDLboTlKJ4lt_5KdnNLgVvtb3tJvQNBNHe_RDd4wEh9E-_haFSYmZd8PzRKtUmZJBwWlmEZQjxBroxVPQSHOuNdIFaPexXOp1572OW75EVa7Hee3n4FCw8SWYcXqHM6TWq1FGZmJHxeSHlKaKW_SiT6KdH1JVw_SNRZ6oNgwNrtiQRkA7P1sDBY4YpzPUu2h5q7Te1VDlEmfz53zdVRnNYyHOflSa0nF1FCMHv7-z_BgDQDpRN00uKLGc3xV4yvC4facUd644Z35SDrBg29xIyFdwL5J5BJ5t0RVCSSaKz7kJn0JJjab7k2liiWvwnIWmwQyV1Vc5FYdx8HrnXjH8P265jqOhl6-JYIJcBNqeM-Qs9o5S3nCiH_WA1R_be8sGOGJhZtV9cnN7QwegdMGXzYe5HFRdp24r-qkaA955pun-71cnDNcKu1XBcAzNv7DidoErI4hcnl2dy0D7jny0CimhrsXhlgnnMmIr6S-o4NZRctrR_m5frfv3D6O8FYNJOJfIAPjFvLXxOmz9xmGB-kgXF7NUKG4Hd7IKiVQboWt3e1C1EBQY1dFPJS9PCoX5EeQYd8QyT1b3xDxT04_BNwrI3qK9rWQCN7-V_NR2KMrcEE63Xnw"]
    }
    
    var format: String {
        "json"
    }
}
