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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDI3OTkwNDgsImV4cCI6MTc0Mjg4NTQ0OCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.HEpgsKQL1rEGPXDA3KNt7YD-Z502lTfHrx4kvIEfA5n6ZXly2qGdE7F-wICx5gE6XcYiri-7gLFBTlAZJ99Q8B70ZegyS8gXsZ7hHJHUvXi7KnXXPVB_oqa-S5o_6MlZMaWlKLMmZreJ_aVJGN0XOh7FU5LoYnIE1Il7Mfdecm7a-V9rxxPJaIg3CX6q7sUXM9W78ABYWXCGagxvu8o5MRjXJBmb58-7C81-8fpjvZS1jcjkUmAhIaDnK_0FO5GVmeHrMAqIdETf9dHkUvqzvVLVtel7li_wP0W5QcyjJKbTsnIL_9kW-U0HR_iKpX5IVjFn1xYabvdMzU52YtFongFpunwPZZufYVrBmXdFzKWzWezxT9OABmPAdj-LULLwOp4iLUkfRZoVjjPcqnVwi8vmw8BBpD2mXqwt958mE6ow0qlof6jNMR384s0Y5PFQnryWkW7vxkVypvLvPpDbkSztXOWvwQnscMtpt9O-_Zcxw-jEhPRjqMlcLpDcilIIfL1hNrJaXcUgvSSoN8cVTpFTW1ebEfhM3ssO4768jpVrjaT1JDwJLJvczK9vFRRhItXhy8x438mKCl4OiLP_GqO5OxjQubtRhxmpb4lb0qCbsSlwF5LM_kPNpeB8af9n-S0RD6uPXrEom6uxEVc4Ks3waY0_oh_mln8RNoABnDc"]
    }
    
    var format: String {
        "json"
    }
}
