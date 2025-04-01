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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDM1MTU2ODUsImV4cCI6MTc0MzYwMjA4NSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.XqHFqOspdebHIfFxEzKk_9pPBcYMduygrCEqxHmMakaSZsPgmaTcS72yZb62FoqztPE32hbFOK1UdnW2QDy9eM2KW-gKtw2thkCPlqbtPNkcaxKFjfmUoX9Hkg3HZUaONshYdzFy8clSw07HziPGX8EiBbxI_m_KXbH8NJwbOE-cPkla6A47GhiuVS78vXs2zlEO1ncOaao5_9QBflJhkUgpww_Z2-bPZlfoMpYLhJvh6Ii3CA3R1sJXH73tgqYgteqmPhXPDC2Tl16dkBbTHuMz5K4RgYNVyfugbyCvwew11mk52EN5lbc6osTPa_jUZoAToisCaWFi7l-sks5TfzcORP5hDaI1Ef1uUk_9CMBDipIsOfIQsN6jCOKDkL6Vj-i9IcF7q8bNXoFNg8asbSOGT67kBIkZwN852mXtckbWlSWhmGp6_Jourgp_K3UvtzhunXjw3L_WLLPin5eMB7DGhgrjXrHw4m88xQDxm-2MVS0iBn9FmmQtKycXsMJguWd7fQf5hHjbMgAS9ai2bbAQYygRr5MMV2HoeXoL7nttKgiZ4lhEkXXDjL5j1OSKC7RYcGUK_siT8Dq9wS5YRwYu2PCZANKXqseO455tx9s9FkZoyrnOKsA7PJcSU1FLbWBb7eTMIAbua7TbJzmovwvmjCiusKW0CNAdgnADZpk"]
    }
    
    var format: String {
        "json"
    }
}
