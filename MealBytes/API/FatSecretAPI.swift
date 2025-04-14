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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQ2MTE2MzgsImV4cCI6MTc0NDY5ODAzOCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.Q-dyK-Yr9EQ35U-gQ2OVAeTEN-PgITcPjO9o-quXZArEs5NGvOY9EfCSIYtIWR6Mg9iskY9fuflr6n6e0qqBlnJMq9R9Dx0cPBf6dae5mCWxyCnJq6mOKZffwxF9GPrWnS1sOAia69Ud1Obo6ByJ_ML_0_wskyyvVISOu3c9y4eks6yNc6tSt0f28Hf6DtYDTTEmYjpR9esbulne4JlEC4K9cugubiDxHuzLzdfjVXLcggoSbWlW_nvBewXd649YYNui8LSSiMuXbkAYVz_JCqBujwExjHprjkEXg9f3hU4tZspOuzEuL83NcHtWf76lqtSddkPoTQgeNCgSMR2cvR1p0UDNze-cBImAAy4jzI9WOgSGF61JsenvslD6usPHMUh2vJpLmZA3jpKEZUZ-JHKsdQP-hFc5FD33YmUSauT8O7JJhT7uv8NePO0Jgsc02v3hkebpEZD7MIZgNIWuq2sEXwpcf6RCZAQoRd7L-Ir5JRK8G2AR87wWfuZxJd75pgurVsYS3s2o8027AyBuSba7lyIZt8-2rZiVWRxi0-qslDWkkNMan9zCT9ctaxc1P8B0dQbn_EizF3x1FeZ_cYktVjcDU6eN9E76K3orBpMMPCXSBVWW_O03s7fyCt9TnYR-qRXgbjRgYqh0kUJx_TMZt2deHu1HlxYtibqC3g4"]
    }
    
    var format: String {
        "json"
    }
}
