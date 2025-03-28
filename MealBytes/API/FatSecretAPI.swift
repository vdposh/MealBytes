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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDMxNTQwMjQsImV4cCI6MTc0MzI0MDQyNCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.pvB3V8uKkZ-OXKKJFfUTANTcU8UZeF32EsORbUQ4_Vt7RCYi1LZVi0WjNrAifSu7WiTOfT51yCS0qsdcQS5xkSUrQfIsGV0JLi4kJfueyCjTBgBj9ZWT-TGffcnp_BanlMIpaCCs4YlI7yt_RF_EMCE_nXmuDEDJMPxfztHTBuimUxEfh7HH1NO9Gj5kI0ePpEilIYuOfeiRwqtXDjmIbTN5IwI-zEyBoiVSh0J0EHd3p8-sf-VsEs2cY5jOxxr6825bbS504V-4GDk6RTLwk6OXVRu_U9MXP4sy6ZM1u8XPmWOVdTMguttfXLPFa0NroARWR0uT1PgPz85Pc98vj8XLjlC5MhdWVAuMaQB7fCk9xZpt5pnXf9D-u3uzJMop0JW4U76Wo6JCmfrHYd67TV4lmW3LedYEewcc5kzal45yCnCmj_frBb0P6Zx9bGC1s-uyvt7U2Oho63A4cfK2U8mlfWaK8GA2VCOqV0E_Rfjowv83H_JQtrHvlvKfed8ce-7iCHHIScelZou4vHXKmuvXaD8_FtZ0pY1HZyvNQzJlIruDS3D8N9Ofn7vIlMYakDFIXH4bG8h5Tp2SA5-Dxa4ShyURZ0FHqPxOZnk1WMIYAI1a1JGOZPqo8ko9v30BSq5AzWW2MkYkqV0WDZZrOipBpNKgSpZ-BGhmHWV-NlM"]
    }
    
    var format: String {
        "json"
    }
}
