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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQzMDM3OTQsImV4cCI6MTc0NDM5MDE5NCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.MtOzhKiFj6eKmsNf0tHbJHA4I08bekwlVpM-X_J7NUI-pxrVJySklCCmPFwW-7E8AmqzjHx_qP5KyHxuyfNoZzRzR---L6iLBlP4zK1ZiWi6G5yqvZy5EpNPHFBQAowU4A2gih1KmiRK0cmS9aHIUCUDTvZ_s4Gjm6VasCrHwFheFWbhzp8tESCVIpvwAD1dO7I_5dBiinLo0ZJMcKNm7AWBtTK4N7m21xG9IU8gor1jEkNXqnZkxBwu7gmOcs2jRJkgvYoceph9MMGUi4HfG6XDD_cZuSlVipe1I5z-y7ge9ozbWQe9yDEvD2szTNnSdfc8XZO7_V8IAWbyrlamjk89jK0jA5z4gzezxMKtcyjA_e6cUl2YwbgifE7WclpSuallsECb4QESI6zVi_Xly_nd2nb3KRc9PglyI00QXT1F7lF_SW5lzWCAn0PhTotIQgi7BXzv90IHHRSgPXOZkXM0rNFaU6H2WAdU5Nm2uiKPAskrcITFeeHuAeQ_O0FoiKUUFD6HYY7IcLje4b6SjMgmGb1GPU0e1muetjb4SeF-lk75fVzPhpMlgAM6PQH5qBS2LXY6zg46kiOj4l1cuiGLa5a41yzQC-UzitMoTc53RDAGcZ_bi7extWEd2MnWVC1aeaDs87mpf-IGWp4fkp8DGp46D1X4cm70bw6yrp0"]
    }
    
    var format: String {
        "json"
    }
}
