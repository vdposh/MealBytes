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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDM0MTYwNDIsImV4cCI6MTc0MzUwMjQ0MiwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.aUcFkG8TcInF8QZ2KT39CiyPs-kIFb3oZd_-5xXKB4PImOfk4Rv_0ZLgEEUr4wRkfQDNDaMFIxJZ_q3XiqZZ-V7N9mMCWkmekBCdLddS_GC0GWHf1S1iaoE4gikQKW21SVUI4il5RZTJjL4eiFNfwGkQthgZHibOQOmpaD6ErOF1hXM_eu7jN8MJsue09rWWalwSXO5Lcg9ir-O32uc76mrytymezJHVnP8gh7UuQ_IgmbVlMEyxPu87lcqjt77ClYwbRP_wbbmvHYAXriKsW6neN_K8GTzdBj9FtFu0--5qhrJ7FPRGIsq-Kf1fsHhR8H_XJguN5RI1NJWIsjlVDf6sP-XXW3gqnJCObWBCUvIclGUiGJs6izSQA7k5XiBvsg4nCfcWWPhdfrJwDM3-Fi4yY1JnvDqsAgfzasydej5EFZJ811lxeX09-KJWFk0vx8EhEy30QnvaN6SKaUa-FtwihwH3yxr0PjlIZMqJJ2yErCBNVTbEQsf0JkfmYppUvepaIY2h8xcg1CBrU_QL7hJrDnY2lXnjy_hSOdLeoGWU2IXi-pErgDFXP7MLM0th5WrnmFAVt7Dt9Y5h-YNOVCKfxs7qsgbULZlBm_Ewl6JAil_ePOiGY1zXsbkF3nuad4Ga2japW6nLdoOk38M_I9v1tG1hlwaJlG3KtQM43Jo"]
    }
    
    var format: String {
        "json"
    }
}
