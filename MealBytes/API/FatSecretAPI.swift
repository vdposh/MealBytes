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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDMyNDE4MDQsImV4cCI6MTc0MzMyODIwNCwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.ZIec5S9KQ-McppZLtRJb5CpI3OkCIyd2cAwJ52hkeFmwHu2vQ4vFlS2N1Ny3rjXKeCmmGP2TR_xc9QMc4ERdwjTP4miDn0l0PwmpPqEekKew0ab5pEUazHBP9uHs4p1DJEP2y4jQ8to74Ue3Vnw9SjbELev2OGCAgfx4t0dJlAWt0uyzjZa8wfR98cImepZ2LI1K3sRhn8Af4aylZzrj_UcXyw7ApcHVNoB0ZY7dA2wa7VfFVrB3xDNL0nqCs4aDNBWNKwC3u9u-hz6OEYoCp56X2o2vL9y3hcHZLgpz2RgLPRcT7xbW5p1WyfI0B5VGpVoDPyjKMoDZmg3PGjLBPFUt_t-5mXtEHYIq04FUra6GtrGa8-foQYqZhBpyGFF_pnMHWWg7UQXpeZSll6c9d6croO0V23KK1U_qKt9PKrm3CSkHw7uHuzMDY-7yaUjDcK5c60R1Nn3aS5Csxrk08287HNeLIV_6eQ7Ipg7dTLVsU0nq9NldcvJzP5jc_JTUUt8pODqVnv3yUmgr-C_dmp0iONREkjdRIMDlmGwbGS1f3x5y0xGXh0F-esFfmpRHu16uFtwnMPQqOoAr5wDxQOyZKvrOy0vjubrsc-e5eFbZx6lZbrwfMpYppjPGkr31xdSz8Ulv4Xa5meFqMsejdRCijrAf3pS_FUDnSKabsXo"]
    }
    
    var format: String {
        "json"
    }
}
