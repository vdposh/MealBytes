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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDM2MDMxNDUsImV4cCI6MTc0MzY4OTU0NSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.g4K3qanGeNR7-f0-VV2_r1QweiSxLCY9gtFOEUEG-x6hHnN7IAv9EWA_WZYiyKGDlnPJJcCKFtSy8aRvFNOncPseDVedRoRO6Be6V_vTaOga3tHrVohSoNVG49yCvEJDTrzR8GmjrM1cE3pcuyFMnm2gHS59eDZL_W2GJHljROu9jfkDkBMjOol-04N2fEnZ6Xfp6Qr3uzAytBAnsGQxUC6TMycfMYbLMT6qP_2qrgbuL580zO1LNPY444j6sDbkwDTK34Jx_qEHbIfpvHkJWpiaMStqikg3RgIvIOuD0OJAbSi_oXde1nTWIHdoXebz6leqbdUM97SGp3zBVw2wU8PcsEv3MJxAzwgv1R4ocemhe9o_p_YxvUEoU5oTMKQpvwGofbuUoQJWQFO3R5TBHuDWmCirntJzKDJNhJ_lGGq6HzzypCwCBwTZXuXtgylYXYrQ6_Cxv9fuc48BEXuxsRCVXwPMv509wvPKHpEitKZTWpTcNybwLVyL3n_pFtt-EJxTCwlmyemBpKxf64mVNH4DfL65L-0Gy7kMM4frpxqXtAQKX2ymGwvkhT3993O1R7_1SB6byMIfIut60Ww8imJMRD_mYz5UeGPjfrv791bsrQV_nwG2B85_J8wE-uqNmSFm_tzXmLC5PkTj4krVaIORo3KYPHtPfb1iPZoQTbM"]
    }
    
    var format: String {
        "json"
    }
}
