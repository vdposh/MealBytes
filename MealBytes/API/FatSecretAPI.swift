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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDIyOTM2MjEsImV4cCI6MTc0MjM4MDAyMSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.N5gKrDUEy9tLSyID9NzjFlR-03PjwVdQ8ToeOwtrVhOxoVeUIF3uUVl06XCFasHshBpMAWphysjnS84CoLjXeHc3i_Hlvxd3XOodKjLgaZq7Qa95W5jlpfOU_-DdORAWzotT1YX5s1ynUqK5WjFRIxmLfZtLzl74po-sP4YPXWhIqbFRU2F6sOVWUvlzx_OE5dw-AKbX_kMSS5KcFYWFulB69pVAKx458UJMIaLNioSSg_eLZIU7mb0gHNURrCTNeYQRG9cVSt4XHW9a2EaaKaJSkbHNQ0LIJjNKQMFFzPfbp0oSYMwFaMft6aG9Dq5mQXqJm1FoNPWZfMUGzY1fKsgQtAcsuOM7fCwyVASgvJJQvAy5rs74_fdL3CpnndsVh8QYLes2pAA-RNYBV1G11GKrR0H1Rzf1IwEr2EFoSmW9b1hq2VaXEAmDruTAW1rou5qQtEOrV5UMDa0qcY4Fea8KhtdVOO-GTKanmvuXMhrRoykA3b0h72of688j0Ed74OFVfzmEqH2cxAIuGxda4GRjf-GDeb3VK_yMaOsg-Mt3zC98a6feYLhFw1Cb_okLi_7XrHIIMCcMgAoBNNARq4T8CzpoV6OUN_gforOywcc4Ton-FCMp9h765Y-UfxMCtk-KyfF_rcUb2WVI_NW5k_AWpUgqdH3GahJyxbNIS_s"]
    }
    
    var format: String {
        "json"
    }
}
