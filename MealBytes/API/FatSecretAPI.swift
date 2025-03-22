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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDI2NDMwNDgsImV4cCI6MTc0MjcyOTQ0OCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.rvQL1yH9e-LYHy4v5zZ-1ZShY2tgTsfm0U4yedEoSei_eXUIja5E2rIZl4K8ywGJvDj2QF1-6nWaFst4iUTuMBPPZ-HM8TmFlw80BTtii_55scbT1itixqj1FG40AS6hOU-GNr5wEOycAsVI7sJ1jXCjnOVaZMwgxB7v_HhhMPrHTHkxnURyPMMxaMfsdArMdCx2-kc8p2atrT3WHuHba35lnp7zyEIZRUuyoKZvXwfAVjTczp8kQXdTwbCuS5XKxtZjG9u_odVOmiP3mW44G9rO71NeMnOOe2htXYyC5YJR5k3vvSBmAsY-dXFXf7ZM-QEwpB-4CG7Dv6MNzxDbOcYNgkHx2Vp5e5JGe7t17ZrFlXn1-DiR0Kmqb90TkVVeh_yjdDwhBXdS-n3nhYAlkLL0_hr2SJFFh7gfrTfLXVB3NRc7Tj85jcgbIjVRXIsNFpepeH4_8Sngf5TjGbBrduROVFnRgncAUvLaCdDNFJ2JIXKm9PBx9oJ1XoWkh_z12xPTFTGRBfvxeFI3X-oa1uRZW26viThmI6KN250XhtF09ksMijm5MW-owVAOYvipeo4nXnc9IyUqbFaAGETt1_L1W8Y5KOH150zZ89INnK4mUOfWGjIQ0uuNWqMETht32wwlWOh0Bcd4cXLeF8L2KLrgspxvXK20J-sAZzq8ZdQ"]
    }
    
    var format: String {
        "json"
    }
}
