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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDMzMjg4NDUsImV4cCI6MTc0MzQxNTI0NSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.QEukRAq5RVm_UZhsGs7sy928SsbmYPbISduU7ud-DV21b6KoF-BGKErHHz41-e-CPToUz2fBuBDqJ3a7KdElnllA0TEAjWQwK-dXF0pcYSfQ_jjuprkD9YqEh99TDJQfihn0WBvDNE-z64iA8_ML5knBgx2x8vmEVVbqK5Ftect2nIQ32Eu6NHSdYRrMdCq4j-oiz-tjlvpmBxEsj1ubcsD1HBE9fHE4ySA_4tL82RM5A-_1AO-JTr8a5z3k7K3TB6unazwCJnHYIudS2163FOSrNNZZtlafyPxZ-RNP9yQowqQxNamZL-cRbm8z_axN5div485XDsVOOGotS0R64aSGOvukYD1U49q2ADW65wTC7q89SSDVP9ThGwAnKq6FtMVLUSSdP1HANXILonJQ-T8VZ3s1RRgDmI6fXYCFkyoF3rQpwsuVhcsve0DM6X5ZX3Y5frdVRZ_U0hHimiEbLnjXmSSE3JQ18DVsDtx5u_fhi8yquM4QZHua2QBkJBxoQTAW5BDjTVaHTvjTJVYhjilPq5_P8VvqB3sQ7rYxN5eENQQykdxQpGL3f_snM89j9lOSil9jiiRgp11QkoH-GEVUzegc-8PxXQM1gpYZEQfsWZvv5avjpVzVy5EE1GqLwq7_eXVy6D_61pyPC3GJc-uw9q168OgjqYRkEFT0abk"]
    }
    
    var format: String {
        "json"
    }
}
