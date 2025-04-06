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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDM5MjI5MjIsImV4cCI6MTc0NDAwOTMyMiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.VXNEuh-oPfcElEzBwEafXW68RQ3QDDuPLUQ2o6DoqGw1tk5AoHf8LSK0YfJwZU-F4QXnKsy4URZDxCabcH6S80t4s9ZP8FaDBbKbd2woEr8wSvQQsLLARdMf4bBM8oR9m5a0K9xQqHUUDNBARQwI1Mqt1ZIO_iDOGITfJTR_3zq1RstJzQ1ZUDiyDWKyFbkeevxN5OtRkCucDhpRxn5ulwNckb1lNyd9c-QSoZAI0KRnPIIW4JrJYU6LYd24613N5jg_9JaniM0x7YQrI7gEYuc-wNzKbssP91dc2teBgeUJ9KxImBi_1-irdxQv0D7W4F_8ZAQZZELPtADM8xAeTki0I5wl8Mjj38N0RdPbfhfPIJtDZ6_5HYecPO7Fn-zfxuJW3dWAkZ6xw5iWKDU883zfxQ3AswBtmI3GH6JFK56zG_NQjpBv0HtGga0ROkq9i4EN-bWZrb_eF4vyx8aEuipt805isrDXgfGjC1uDvF9RF8O3Ad96Dn63Z38DQdqIuzAW2sEVOEc_sJXGTlQtJStJLmJwh4Lt2zacovps1Zg8M-KqzVqrGj8eF7dqDk5WNG8QN07PtJWOkwWFEoeaixKGQxNos3RpGTH05FaEY2_4OKk6OmJD8kcKFhhvsnpvsdZn09Xk6cD0HycIQVev9iym3vFPhfZHcZxcBx3vMfI"]
    }
    
    var format: String {
        "json"
    }
}
