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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE2OTQzNTUsImV4cCI6MTc0MTc4MDc1NSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.m4bTOWABOU0kc3kHGUWIH44f-hRfBGokij5Djke_Ou5iO7r-RsbDIEZnnEFeRPhZyMOfxw7WY9vEFZ0IskKiPncj4b2SEbu7NrVjCGcw-F8ONBl3i60mqwPwfT5dS2-zPpXqyM3xnoqKtoSZ2vmNk_Wm6uwalWLYoKYEe-ZVThWx9RlWaPT7t4PJMpCfNcZkXZoJSL4ylrJ90vHsCXF_PB3k84BnNJD3TP--pL-qOez93o7czZeaDPb1c9T3zU8mSdG2B9qtawh8QLLy0jBIzQEEeGLW2uFMaraG8ygUlBpVeg3B3kEeR7-K9jBTX7dSZ0f9lPe3hnXvV5PbDqHTT7yEfc8zeRQ2UnM1mGYT21ppQ31qzmKx_YHs5w2Bc0-Zy2Y49Lky7llkXqaBfueAThg29mJZr42pR-1jexnrbfuGUzdtCng369HBbSJYb6TkByhQiAOzTwqW6Ll6Df2AW3yjSRTwTEJiau_Ucu-9YGpElFxgQi3nUHi-Ya6oWocWOgQvsVTKzTU9iMBX8WMXvirxHx6fs0QODgbqdMnwFB-T2ja9369dxC7DjcVPa6D_dxPwEmMsPp5rfwohtaPBK1um3MXQOVFxZVvMoB29A1eT9ublk6py4nWGwUC9JpYnkbrlFRZWpKXwojBQpqaVkT9Mu6yOHhnDprBZ0isgm7A"]
    }
    
    var format: String {
        "json"
    }
}
