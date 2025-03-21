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
        ["Authorization": "Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjEwOEFEREZGRjZBNDkxOUFBNDE4QkREQTYwMDcwQzE5NzNDRjMzMUUiLCJ0eXAiOiJhdCtqd3QiLCJ4NXQiOiJFSXJkX19ha2tacWtHTDNhWUFjTUdYUFBNeDQifQ.eyJuYmYiOjE3NDI1NTQ4NTUsImV4cCI6MTc0MjY0MTI1NSwiaXNzIjoiaHR0cHM6Ly9vYXV0aC5mYXRzZWNyZXQuY29tIiwiYXVkIjoiYmFzaWMiLCJjbGllbnRfaWQiOiJiOWYxODNlNjkxYTY0ZTU0YjExODFhOGNkYWUxOWE0ZiIsInNjb3BlIjpbImJhc2ljIl19.D1wAQbuEwmlEapYRihd5jhCgX4_QfBXYK8HoHsi5NsRl8IJD1D-oC1UJzaK1Lrx5PHzwtuU_Q0dPfuh9jb5jSXDbIHrDAZEhrwfaxPPIHUKMTuoqFr_vsTQcBfBjNfBMYV5QPWYF8WjJESHDyEhUVPCOcoH3TNKb1fPfkw3MvfapwwyZ13jI3tWA-5F6LJuYYzCvcmCRW1FEckrKTPhr9to4Ex8jx_MaTfMEVzKgDfMNI98PZHb7p95vzEGLaCdXVGN-BQFj3Yqb-fxPl1sUz6LJ2B21Z6KrN4hnJOwljWaanCLeOwBZnDWwiMhFzh_Yk7TvyHiOZQE__z1ObM4LiPe7Dh-lQvmQs7gdD8JTrSLujtfiISUnHUlPt69RirCKDF6ig9M0rvAgWa0d7Nxv_VgKDLjUq9nYUCcxCEwYVGguc8Upe_8IVz14B2WYfy7cvMRl0mz-nq2YvvjHiwdI7MMH5y8DwabusAkcb54XWcysUmva6mddYR6ckIhKwU8agW_Vhee-ISz2q4o99omGohzm8TGgYZZrK7l4LZxC_fdaCX8uOyX7Q47_uIL1meJYdGJOxJPjpGJ9DeamXmfn0HGMh7QM70RsTRDNPQqog2LYGWeCOOC2edFYaNUKtYG1tLKXEqrLtCalsMX_uzKGOmK2-Y3lkKwfqHA2atoZbqo"]
    }
    
    var format: String {
        "json"
    }
}
