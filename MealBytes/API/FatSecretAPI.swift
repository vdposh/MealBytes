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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDE5MzU0NDIsImV4cCI6MTc0MjAyMTg0MiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.sQv71AYdboj2VHL0f8VN8ZfE_BcIC3XcbTX3xADeH1FXnAe2z8zh8Uqg39fYes2qFkrXvYlyAWB53AeCxVYjHd0FcROk9r9ErwNcyBUfqN2YRFOqHwDpzjudY28cwxryDNKQHfIggT7FdH_hKswODVRygM7rySrl4okgqGWc7aJwnnhaS7M3XbYh7ObbPPbNNWRURGWHinFXJr4fLRNBbXkq-IxXIHU21JtTCFmfFpTyPJABqszbbI5p8zE6KTBWMTCJyTtEcJIGAxsvkJdHikogSVkvYKFdOQdHTibgVo9b4hhdPwd8JV-29c5UAtyBtkWSEk5YA30k5emnkb-0vlDt_dCreAaKxFW_HAWdUmZlnixR2dM_9IQ4DFh-OrtJdxOCJuiXwTO_zHHse2y4dK-7wnXdAMzbEXkn0CgRfqL0-1KFKPBfWSggResU984zRm4cPsmtfbT4edlPCUNmBEr91gtke3xPScRSMaNSXKDvpwj_IvuTmWbAfzqE1PfLfx2oDAn3iVs2SY1joaLGzpBWBzAB3VEc_3wPlg8ttuxkJlm3z_kpD_K1GiFpTY07uHd0MufP69gPvOhxa7cR_1z-EA-EilRInd3iqINuKhHtYLj3noWvQx0n6dZKNXqYct8-Wgz14jL1qMTjoMg2DYXsZmzpfrkLADtc9uzHXpw"]
    }
    
    var format: String {
        "json"
    }
}
