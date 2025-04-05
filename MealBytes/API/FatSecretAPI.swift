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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDM4MzU0ODcsImV4cCI6MTc0MzkyMTg4NywiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.dHpCKalZsQaMRlgsSqkimzEiShmw2Xk7FNVrOb20FY1THDfJcgXBtdjcZQZ7Hj5OTSGEdnLdg5Hy0tZAusuRMyftAWFQJo2c2j2vhv3zjh349i3gY0WUaE-HOmKOHete0-dZg0h3K0fTagXPy8a5Tfw9sP7BYlQsW2lC_RmHdvJNZmGUoy4iEfvSJLdSaLQ79cSHMLpq9XmAo6LclxtCLmpOiYz6mimBvzzJsr4vAijlrO6evnddHDoaGtp5gpTRCk5o8dymmkUFVRVPpbNRzJTuX_faAzIdxuvG3d4VsEKZTagGZ5o1dYBZYCyRHqQHaWbogtTCHYooY-lHlPaEY6hsrUwluf3yrudvr0GeNmOoGJ140aQevGe9fNaFLqdyGZmCHN-7-9SOu_pKw0yNKxt9tCPj0A5xz_j040WhVhpdkkFU42S4ToX3ZY86GddH4aPH0GmviSvUWuqUNO-8z-Y7eFwGPXGq_Wul65MfyQ39XYbKtNcXV1TKIe1Tz7pQ-40S8TksvMhdC4j2T13l1ChYNV5HAU0gGH_7GSsnXnoH9Vns8WCn2qb8tTEmbVqS5xB-UyDFGx9qh1DEVQCNgZfcLbjkFw18InA7Xy2aT9nBtkYbIL4Mh9sttB5wIP-54dX_AvLJgme7YHDaTt9Fn6P4D8mHJirB-1g_IloBt7g"]
    }
    
    var format: String {
        "json"
    }
}
