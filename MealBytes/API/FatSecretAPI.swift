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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDIzODEzMDksImV4cCI6MTc0MjQ2NzcwOSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.aMUjQo19Pl94IZC-u3Fy2qJvCkWNwj1_guvD5VI6_94J4eGq6z67_xAXePQzLgRLimBkn5SiAbTA_AN5Zq7fdkPibFhEVDKqVaNY8XWtEIq0O12cuDpqp3BTwL-nH2NvQ_tMC7bxHX7b1B_wzTSpnE7H9tR_F1Msohr3t84xKhaAOF0JYgp9B2Gx37ujyN1RMDjHH5P4BcfJFBGWOXqg58VPDZJ3sz3RH4tbYkeM07x5QpxdAxKipmYNhKog2Sk4vqidvxlnZUO3L18j2DFvX0jL_SHj4OfhuOhQH2PcCSjQww0QDWPANQs2h1tWZ0FfdTbPZhj6YA6hbnsmCWweBsUrtnJjsFvFAOb-uyhj3IK027QeHfu5AJN8Sm1-PxH6QPjU1kX8SGajMfI1iWW9pEPxK_2Q1UliVN6iTNJQcrS1kkY-1lsVomFsUj9PHMiaoPDu7y7YFSW3d7AKjFhHpRfi7Js-QycV6dZstcHT8j54BIITL2haYIyZPu-lap-vZH5r0qHjEWtv-1dK1qD3Iz3V7A3WT56vfXStxSCLc-ZmBU9CMSuNyHyb0z5Lcu_fujo6JO1gfWbEZVGlmqDvwKcx3WYyWNu0b24DPOh-KnAnn0ll3I1PtBxShOgAfZS4GQtlP9DmCLFZApw8f26QC1FnoUNVFnGnLsEzM3rBpVA"]
    }
    
    var format: String {
        "json"
    }
}
