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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDQzNzQ3ODQsImV4cCI6MTc0NDQ2MTE4NCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.LUXwJzXaTMAJJ8sePpVLU-KnDeWZino3pHh3TEBbBIa_cicgMC9L91IJfI80M0hTZ_hxwwkZyogNp1rEAZPd7zHApbyd6jrK8jH9dc4xhbuSWiMI3mtM6XiJBnTt3zyX__0361ql3EEX9O2Mqqof8BIQ8kpDU66ogz419Y1SQx8LQXTPR4vyq-JTOpQZ8a2clPmhOyefs_aJL3NwAOsFvI_3oDqTh_OE0p73hk37KrOmimDILtJARAaS_DE_pzpyiDeAG_rj8DUB9tVinBkiVvZRdOXnAGROxQ6SpbNke6_rAApbRywKI-4BA-LtoO1p55iamaYeg2yHzp87NJCXdcLIRuLkrLOa9mTszCajD4cbltm4Dj5-a4vqWxmuxV5REVyRSJJoUltds4fnu91B1Xz_wbrByfDFlTBfevtGxAzcukU3INVUXJ4h4sj23u_NSsnNIUHKcpBs2ULpOfmNLrXFdELRjx8KRzn2E2DEMklUMbeHABOR4uVfj7IUPJMQE8WbbHwuBk03NRzr49lo4sBr855kE-Fbya2dtzDVnlUENGVUcUfF98HI2irPn7Ep9cBse0JpUTHkOR4cmpbvJnDW1GtlnFt5NoDEWBr9OSfILnoI_k_R7xnEOnQM6qgUP7DOoHfbgJQYvtnLmMd5Kb1IgwJSqNH0ryU8sY_9yFc"]
    }
    
    var format: String {
        "json"
    }
}
